# Energy Costs

Service to calculate a users best energy provider.

# Dockerfile

The dockerfile has been built in 2 stages. The first to get
dependencies and build the app. The second using a distroless
build with only the bare essentials to run the app.

The file can built and ran locally (exposing at port 8080) with:

```
docker build -t energycost .
docker run -p 8080:8080 -it energycost
```

# Infrastructure

Infrastructure has been written using Terraform for ECS on AWS with high availability in mind.
The project consists of the following:
- A VPC with a /16 netmask, allowing for a total of 65536 IP addresses.
- Subnets with /24 netmasks, allowing for a total of 256 IP addresses per subnet.
- 3 Public subnets, in 3 AZs.
- 3 Private application subnets, in 3 AZs. These will host all application servers.
- 3 Private database subnets, in 3 AZs. These will host all database servers.
- 1 internet gateway.
- Public route table, with route to the internet gateway. Public subnets are associated
  with the public route table.
- Public security group. Allow tls/http from anywhere and all egress traffic.
- Private application security group. Allow traffic from the resources associated with
  the public security group and all egress traffic.
- Default security group. Allow all internal VPC traffic and all egress traffic.
- VPC endpoints associated with the VPC for ECR (dkr and api instance endpoint) and S3 
  (gateway endpoint). This allows ECS to pull the requested resources from ECR.
- Application Load Balancer in the 3 public subnets, associated with the public security group.
  ALB has health check configured to for `/health`, along with a http listener.
- ECR repository to hold the docker image.
- ECS task definition using fargate defined with the minimum compute (256 cpu, 512 memory).
- ECS cluster with single service running the task definition running within the private 
  application subnets and the private application security group.
- Autoscaling scheduled actions: in to 0 in the evening, and out to 1 in the morning.
- Autoscaling target tracking policy to scale in/out to maintain a maximum of 75% cpu 
  utilization.
