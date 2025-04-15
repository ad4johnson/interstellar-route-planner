from diagrams import Diagram, Cluster
from diagrams.aws.compute import ECS
from diagrams.aws.database import RDS
from diagrams.aws.network import ALB, APIGateway
from diagrams.aws.storage import S3
from diagrams.aws.security import IAMRole
from diagrams.aws.general import General
from diagrams.onprem.monitoring import Prometheus, Grafana
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.container import Docker
from diagrams.k8s.compute import Pod
from diagrams.onprem.mlops import Mlflow

with Diagram("Interstellar Route Planner Infrastructure", show=False, filename="infra_diagram"):
    with Cluster("Networking"):
        alb = ALB("App Load Balancer")
        api_gateway = APIGateway("API Gateway")
    
    with Cluster("Compute"):
        fargate = ECS("AWS Fargate")
        docker = Docker("Docker Container")

    with Cluster("Database"):
        rds = RDS("Amazon RDS (PostgreSQL)")

    with Cluster("Monitoring & Logging"):
        prometheus = Prometheus("Prometheus")
        grafana = Grafana("Grafana")
        s3_logs = S3("S3 Logs Bucket")

    with Cluster("Security & Permissions"):
        iam = IAMRole("IAM Roles")
        ssm = General("SSM Parameter Store")  # <== Custom label with generic icon

    with Cluster("CI/CD Pipeline"):
        github = GithubActions("GitHub Actions")

    with Cluster("Kubernetes Cluster"):
        pod = Pod("K8s Pod")

    with Cluster("AI & ML Stack"):
        mlflow = Mlflow("Anomaly Detection")

    # Connections
    github >> fargate
    alb >> api_gateway >> fargate >> docker
    docker >> rds
    docker >> mlflow
    fargate >> prometheus >> grafana
    fargate >> s3_logs
    iam >> fargate
    ssm >> fargate
    fargate >> pod