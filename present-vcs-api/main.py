from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, ValidationError
from typing import List, Union
from datetime import datetime
import requests
import os

app = FastAPI()

# Use environment variables for sensitive information
DIRECTUS_URL = os.getenv("DIRECTUS_URL", "http://localhost:8055")
EMAIL = os.getenv("EMAIL", "admin@example.com")
PASSWORD = os.getenv("PASSWORD", "d1r3ctu5")

# Authentication function
def authenticate_directus() -> str:
    auth_endpoint = f"{DIRECTUS_URL}/auth/login"
    payload = {"email": EMAIL, "password": PASSWORD}
    headers = {"Content-Type": "application/json"}
    response = requests.post(auth_endpoint, json=payload, headers=headers)
    if response.status_code == 200:
        return response.json()['data']['access_token']
    else:
        raise HTTPException(status_code=400, detail="Authentication failed")

# Function to create an item in a Directus collection
def create_item_in_collection(token: str, collection_name: str, item_data: dict) -> dict:
    create_endpoint = f"{DIRECTUS_URL}/items/{collection_name}"
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    response = requests.post(create_endpoint, json=item_data, headers=headers)
    if response.status_code in [200, 201]:
        return response.json()['data']
    else:
        raise HTTPException(status_code=400, detail="Failed to create item")

# Pydantic models for structured request and response bodies
class HealthRecordContent(BaseModel):
    pass

class AllergyContent(HealthRecordContent):
    allergy_code: str
    allergy_description: str
    reaction_code: str
    severity: str

class MedicationContent(HealthRecordContent):
    medication_code: str
    medication_name: str
    dosage_instruction: str

class DiagnosisContent(HealthRecordContent):
    diagnosis_code: str
    diagnosis_description: str

class VerifiableCredential(BaseModel):
    id: str
    type: str
    issue_date: datetime
    content: Union[AllergyContent, MedicationContent, DiagnosisContent]

# Route to handle presentation of Verifiable Credentials
@app.post("/present")
def presentation(vcs: List[VerifiableCredential]):
    token = authenticate_directus()
    try:
        json_output = {
            'vc': [{
                'id': vc.id,
                'type': vc.type,
                'issue_date': vc.issue_date.isoformat(),
                'content': vc.content.dict()
            } for vc in vcs]
        }
    except ValidationError as e:
        raise HTTPException(status_code=400, detail=str(e))

    created_vc = create_item_in_collection(token, "vcs", json_output)
    return {"message": "Verifiable Credentials presented successfully!", "data": created_vc}

# Utility function for local development and testing
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0")
