import os
import psycopg2
import heapq
import json
from typing import Dict, List, Tuple, Optional
from psycopg2 import OperationalError

# Load environment variables
DB_NAME = os.getenv("DB_NAME", "interstellar")  # ✅ Fixed DB name
DB_USER = os.getenv("DB_USER", "admin")
DB_PASSWORD = os.getenv("DB_PASSWORD", "securepassword")
DB_HOST = os.getenv("DB_HOST", "postgres")
DB_PORT = int(os.getenv("DB_PORT", 5432))

# Establish database connection
try:
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD, host=DB_HOST, port=DB_PORT
    )
    cursor = conn.cursor()
except OperationalError as e:
    print(f"❌ Database connection error: {e}")
    cursor = None


def fetch_graph() -> Dict[str, List[Dict[str, str]]]:
    """Fetch gates and their connections from the database"""
    if not cursor:
        print("⚠️ No DB cursor")
        return {}

    try:
        cursor.execute("SELECT id, connections FROM gate;")
        data = cursor.fetchall()

        graph = {}
        for row in data:
            try:
                conn_data = json.loads(row[1]) if isinstance(row[1], str) else row[1]
                graph[row[0]] = conn_data
            except Exception as e:
                print(f"⚠️ Failed to parse connections for {row[0]}: {e}")

        return graph
    except Exception as e:
        print(f"❌ Failed to fetch graph: {e}")
        try:
            conn.rollback()  # 🛠 Reset transaction block on error
            print("↩️ Rolled back failed transaction.")
        except Exception as rollback_error:
            print(f"❌ Rollback also failed: {rollback_error}")
        return {}


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

    # Reconstruct path
    path = []
    node = target
    while node:
        path.append(node)
        node = prev_nodes.get(node)

    path.reverse()
    print(f"✅ Path found: {path} with cost {distances[target]}")

    return path, distances[target]