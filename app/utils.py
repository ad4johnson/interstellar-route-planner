import os
import psycopg2
import heapq
import json
from typing import Dict, List

# Load environment variables
DB_NAME = os.getenv("DB_NAME", "interstellar_db")
DB_USER = os.getenv("DB_USER", "admin")
DB_PASSWORD = os.getenv("DB_PASSWORD", "securepassword")
DB_HOST = os.getenv("DB_HOST", "postgres-service")  # Kubernetes service name
DB_PORT = int(os.getenv("DB_PORT", 5432))

# Establish database connection
try:
    conn = psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,
        port=DB_PORT
    )
    cursor = conn.cursor()
except psycopg2.OperationalError as e:
    print("Database connection failed:", e)
    cursor = None  # Handle error gracefully

def fetch_graph():
    """Fetch gates and their connections from the database"""
    if not cursor:
        return {}
    cursor.execute("SELECT id, connections FROM gate;")
    data = cursor.fetchall()
    graph = {row[0]: json.loads(row[1]) for row in data}
    return graph

def dijkstra(start: str, target: str):
    """Find the shortest path between gates"""
    graph = fetch_graph()
    
    if start not in graph or target not in graph:
        return None, float('inf')

    queue = [(0, start)]
    distances = {node: float('inf') for node in graph}
    distances[start] = 0
    prev_nodes = {node: None for node in graph}

    while queue:
        current_distance, current_node = heapq.heappop(queue)
        if current_node == target:
            break
        
        for neighbor in graph[current_node]:
            neighbor_id = neighbor["id"]
            weight = int(neighbor["hu"])
            distance = current_distance + weight

            if distance < distances[neighbor_id]:
                distances[neighbor_id] = distance
                prev_nodes[neighbor_id] = current_node
                heapq.heappush(queue, (distance, neighbor_id))

    # Reconstruct path
    path = []
    node = target
    while node is not None:
        path.append(node)
        node = prev_nodes[node]
    path.reverse()

    return path, distances[target]