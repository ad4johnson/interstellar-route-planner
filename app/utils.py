import os
import psycopg2
import heapq
import json
from typing import Dict, List, Tuple, Optional
from psycopg2.extras import RealDictCursor
from psycopg2 import OperationalError
from fastapi import HTTPException
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

DB_NAME = os.getenv("DB_NAME", "interstellar")
DB_USER = os.getenv("DB_USER", "admin")
DB_PASSWORD = os.getenv("DB_PASSWORD", "securepassword")
DB_HOST = os.getenv("DB_HOST", "postgres")
DB_PORT = int(os.getenv("DB_PORT", 5432))

def get_db_connection():
    """Create and return a new DB connection"""
    try:
        return psycopg2.connect(
            dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD, host=DB_HOST, port=DB_PORT
        )
    except OperationalError as e:
        print(f"❌ DB connection error: {e}")
        raise HTTPException(status_code=500, detail=f"Database connection failed: {e}")

def fetch_graph() -> Dict[str, List[Dict[str, str]]]:
    """Fetch gates and their connections from the database"""
    try:
        conn = get_db_connection()
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SELECT id, connections FROM gate;")
            rows = cursor.fetchall()

        graph = {}
        for row in rows:
            gate_id = row["id"]
            connections = row["connections"]

            try:
                parsed = json.loads(connections) if isinstance(connections, str) else connections
                graph[gate_id] = parsed
            except Exception as e:
                print(f"⚠️ Failed to parse connections for {gate_id}: {e}")

        conn.close()
        return graph

    except Exception as e:
        print(f"❌ Failed to fetch graph: {e}")
        raise HTTPException(status_code=500, detail="Database fetch failed.")

def dijkstra(start: str, target: str) -> Tuple[Optional[List[str]], float]:
    graph = fetch_graph()

    print(f"🧠 Available nodes: {list(graph.keys())}")
    print(f"🔍 Searching route from {start} to {target}")

    if start not in graph or target not in graph:
        print("🚫 Start or target not found in graph!")
        return None, float("inf")

    queue = [(0, start)]
    distances = {node: float("inf") for node in graph}
    distances[start] = 0
    prev_nodes = {node: None for node in graph}

    while queue:
        current_distance, current_node = heapq.heappop(queue)
        print(f"➡️ Visiting {current_node}, distance: {current_distance}")

        if current_node == target:
            break

        for neighbor in graph.get(current_node, []):
            neighbor_id = neighbor["id"]
            weight = int(neighbor["hu"])
            new_dist = current_distance + weight

            if new_dist < distances.get(neighbor_id, float("inf")):
                distances[neighbor_id] = new_dist
                prev_nodes[neighbor_id] = current_node
                heapq.heappush(queue, (new_dist, neighbor_id))

    path = []
    node = target
    while node:
        path.append(node)
        node = prev_nodes.get(node)

    path.reverse()
    print(f"✅ Path found: {path} with cost {distances[target]}")

    return path, distances[target]