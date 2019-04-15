This module prepares ECS cluster for development environment.
Module will  create next resources:
- IAM instance role and policies to access S3, SSM, EFS
- ECS cluster with defined user-data script to configure EC2 isntance.
- Security group for ECS cluster
- ECS services to gather logs and service metrics



## Inputs

| Name | Description | Type | Default |
|------|-------------|:----:|:-----:|
| ebs_volume_size | EBS volume size in Gb | string | `20` |
| ecs_ami | AWS ECS Optimized AMI. | string | `ami-fbc1c684` |
| ecs_instance_size | ECS cluster desired capacity | string | `1` |
| ecs_instance_size_max | ECS cluster max capacity | string | `5` |
| ecs_instance_size_min | ECS cluster min capacity | string | `1` |
| ecs_instance_type | Instance Type | string | `t2.medium` |
| efs_mount_path | Path to which efs is mounted on ecs host | string | `/mnt/efs` |

## Outputs

| Name | Description |
|------|-------------|
| cluster_arn | ECS cluster arn |
| cluster_name | ECS cluster name |
| ecs_config_etag | ECS cluster configuration path stored on S3 |
| ecs_config_id | ECS cluster configuration id stored on S3 |
| efs_mount_path | EFS mount local path on EC2 instance |
| sg_id | ECS cluster security group id |
| sg_name | ECS cluster security group name |
