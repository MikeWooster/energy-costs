# ---------------------------------------------------------------------------------------------------------------------
# ECS Service & Task
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_role" {
  name               = "mikes-ecs-task-role"
  description        = "Role used as the Task Role in the ECS cluster"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
}

resource "aws_iam_role" "execution_role" {
  name               = "mikes-ecs-execution-role"
  description        = "Role used as the Execution Role in the ECS cluster"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
}

data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "execution_role_aws_task_execution_role_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

resource "aws_ecs_task_definition" "webservers" {
  depends_on = [
    aws_iam_role.task_role,
    aws_iam_role.execution_role,
    aws_ecr_repository.main,
  ]

  family = "mikes-webservers"
  container_definitions = templatefile("task-definitions/webservers.json", {
    image_url = aws_ecr_repository.main.repository_url,
    image_tag = "latest",
  })

  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.execution_role.arn

  requires_compatibilities = ["FARGATE"]

  # Fargate requires awsvpc
  network_mode = "awsvpc"

  cpu    = "256"
  memory = "512"
}

resource "aws_ecs_cluster" "main" {
  name = "mikes-ecs-cluster"
}

resource "aws_ecs_service" "webservers" {
  depends_on = [
    aws_ecs_cluster.main,
    aws_ecs_task_definition.webservers,
    aws_security_group.public,
    # specifying the alb here as this has a dep on the target
    # group and needs to exist before registering targets
    aws_lb_listener.alb,
    aws_subnet.public_az1,
    aws_subnet.public_az2,
    aws_subnet.public_az3,
  ]

  name            = "mikes-webservers"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.webservers.arn
  launch_type     = "FARGATE"
  # Explicitly set the version, otherwise future apply's might change this.
  platform_version                  = "1.4.0"
  desired_count                     = 1
  health_check_grace_period_seconds = 10

  network_configuration {
    subnets          = [aws_subnet.app_az1.id, aws_subnet.app_az2.id, aws_subnet.app_az3.id]
    assign_public_ip = false
    security_groups  = [aws_security_group.private_app.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "web"
    container_port   = 8080
  }

  tags = {
    Name      = "mikes-webservers"
    CreatedBy = "Mike"
  }
}
