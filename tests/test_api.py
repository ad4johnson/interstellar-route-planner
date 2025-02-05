import requests

BASE_URL = "http://0.0.0.0:8000"
DATABASE_URL = "postgresql://user:pass@localhost:5432/mydatabase"
SECRET_KEY="your_secret_key"

def test_get_routes():
    response = requests.get(f"{BASE_URL}/api/v1/routes")
    assert response.status_code == 200
    assert "routes" in response.json()