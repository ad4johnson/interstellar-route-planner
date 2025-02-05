import boto3
import json
import re

# AWS CloudWatch Log Group
LOG_GROUP_NAME = "/ecs/interstellar-service"

# Boto3 client
logs_client = boto3.client("logs")

def fetch_completed_jobs():
    """Fetch logs containing 'done' or 'Request Completed' and extract API endpoints."""
    
    response = logs_client.filter_log_events(
        logGroupName=LOG_GROUP_NAME,
        filterPattern='"done" OR "Request Completed" OR "API"',
        limit=100
    )

    completed_jobs = []

    for event in response.get("events", []):
        message = event.get("message", "")

        # Extract API URLs
        api_urls = re.findall(r'https?://[^\s]+', message)
        if api_urls:
            completed_jobs.extend(api_urls)

    return list(set(completed_jobs))  # Remove duplicates

def save_results(jobs):
    """Save extracted API endpoints to a file."""
    if not jobs:
        print("No completed job endpoints found.")
        return

    with open("logs/completed_jobs.txt", "w") as f:
        for job in jobs:
            f.write(job + "\n")

    print(f"✅ Completed jobs saved to logs/completed_jobs.txt")

if __name__ == "__main__":
    jobs = fetch_completed_jobs()
    save_results(jobs)