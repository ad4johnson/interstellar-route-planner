from diagrams import Diagram, Cluster
from diagrams.aws.compute import ECS
from diagrams.aws.database import RDS
from diagrams.aws.network import ALB
from diagrams.aws.management import Cloudwatch
from diagrams.aws.storage import S3
from diagrams.onprem.client import Users
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.monitoring import Grafana
from diagrams.onprem.container import Docker
from diagrams.onprem.iac import Terraform

with Diagram("Interstellar Route Planner Architecture", show=True):
    users = Users("Users")

    with Cluster("AWS Cloud"):
        lb = ALB("Application Load Balancer")

        with Cluster("ECS Cluster (Fargate)"):
            app = ECS("FastAPI on ECS")
            container = Docker("Docker Container")

        db = RDS("PostgreSQL on AWS RDS")

        with Cluster("Monitoring & Logging"):
            cloudwatch = Cloudwatch("AWS CloudWatch Logs")
            grafana = Grafana("Grafana Monitoring")

        with Cluster("CI/CD Deployment"):
            github = GithubActions("GitHub Actions")

        iac = Terraform("Terraform (IaC)")
        storage = S3("AWS S3 (If Used for Logs/Backups)")

    # Flow connections
    users >> lb >> app >> db
    app >> cloudwatch >> grafana
    github >> app
    container >> app
    iac >> app
    iac >> db
    app >> storage