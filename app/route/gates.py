from fastapi import APIRouter, HTTPException
from app.database import get_gates_from_db
# from app.database import get_gates_from_db

router = APIRouter()

@router.get("/gates")
def get_gates():
    try:
        gates = get_gates_from_db()
        if not gates:
            raise HTTPException(status_code=404, detail="No gates found")
        return {"gates": [{"id": k, "name": v["name"]} for k, v in gates.items()]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))