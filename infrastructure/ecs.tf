
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

resource "aws_ecs_task_definition" "webservers" {
  depends_on = [aws_iam_role.task_role, aws_iam_role.execution_role]

  family                = "mikes-webservers"
  container_definitions = file("task-definitions/webservers.json")

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
    aws_subnet.public_az1,
    aws_subnet.public_az2,
    aws_subnet.public_az3,
  ]

  name            = "mikes-webservers"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.webservers.arn
  launch_type     = "FARGATE"
  desired_count   = 0

  network_configuration {
    subnets          = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]
    assign_public_ip = true
  }
}
