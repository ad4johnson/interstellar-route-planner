import docker
import json
import psutil
import socket

def get_docker_info():
    client = docker.from_env()
    
    # Get running containers
    containers = []
    for container in client.containers.list(all=True):
        containers.append({
            "name": container.name,
            "id": container.id,
            "image": container.image.tags,
            "status": container.status,
            "ports": container.attrs["NetworkSettings"]["Ports"],
            "env": container.attrs["Config"]["Env"]
        })
    
    # Get volumes
    volumes = client.volumes.list()
    volume_info = [vol.name for vol in volumes]

    # Get networks
    networks = client.networks.list()
    network_info = [{"name": net.name, "id": net.id} for net in networks]

    # Get system ports in use
    used_ports = [conn.laddr.port for conn in psutil.net_connections(kind='inet') if conn.status == psutil.CONN_LISTEN]

    return {
        "containers": containers,
        "volumes": volume_info,
        "networks": network_info,
        "used_ports": used_ports
    }

if __name__ == "__main__":
    try:
        infra_details = get_docker_info()
        print(json.dumps(infra_details, indent=4))
    except Exception as e:
        print(f"Error fetching infrastructure details: {e}")