from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime
from typing import List, Union
import requests

app = FastAPI()

# Directus credentials and URL
directus_url = "http://localhost:8055"
email = "admin@example.com"
password = "d1r3ctu5"

def authenticate_directus(directus_url, email, password):
    auth_endpoint = f"{directus_url}/auth/login"
    payload = {
        "email": email,
        "password": password
    }
    headers = {
        "Content-Type": "application/json"
    }
    response = requests.post(auth_endpoint, json=payload, headers=headers)
    if response.status_code == 200:
        data = response.json()
        return data['data']['access_token']
    else:
        raise Exception("Authentication failed", response.text)

def create_item_in_collection(token, directus_url, collection_name, item_data):
    create_endpoint = f"{directus_url}/items/{collection_name}"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    response = requests.post(create_endpoint, json=item_data, headers=headers)
    if response.status_code in [200, 201]:
        data = response.json()
        return data['data']
    else:
        raise Exception("Failed to create item", response.text)

# Pydantic models for structured request and response bodies
class AllergyContent(BaseModel):
    allergy_code: str
    allergy_description: str
    reaction_code: str
    severity: str

class MedicationContent(BaseModel):
    medication_code: str
    medication_name: str
    dosage_instruction: str

class DiagnosisContent(BaseModel):
    diagnosis_code: str
    diagnosis_description: str

# Union type for different content types
HealthRecordContent = Union[AllergyContent, MedicationContent, DiagnosisContent]

class VerifiableCredential(BaseModel):
    id: str
    type: str
    issue_date: datetime
    content: HealthRecordContent

# def transform_payload(vcs_list):
#     transformed_payload = {
#         'vc': [
#             {
#                 'id': vc['id'],
#                 'type': vc['type'],
#                 'issue_date': vc['issue_date'],
#                 'content': vc['content']
#             } for vc in vcs_list
#         ]
#     }
#     return transformed_payload

def transform_payload(vcs: List[VerifiableCredential]) -> dict:
    transformed_payload = {
        'vc': [
            {
                'id': vc.id,
                'type': vc.type,
                'issue_date': vc.issue_date.isoformat(),
                'content': vc.content.dict() if hasattr(vc.content, 'dict') else vc.content
            } for vc in vcs
        ]
    }
    return transformed_payload

# Route to handle presentation
@app.post('/present')
def presentation(vcs: List[VerifiableCredential]):
    #
    # print(vcs)
    # data = [
    #     {
    #         "id": "vc-1",
    #         "type": "AllergyRecord",
    #         "issue_date": datetime.now().isoformat(),
    #         "content": {
    #             "allergy_code": "A001",
    #             "allergy_description": "Pollen Allergy",
    #             "reaction_code": "R102",
    #             "severity": "High"
    #         }
    #     },
    #     {
    #         "id": "vc-2",
    #         "type": "MedicationRecord",
    #         "issue_date": datetime.now().isoformat(),
    #         "content": {
    #             "medication_code": "M002",
    #             "medication_name": "Aspirin",
    #             "dosage_instruction": "Take one tablet daily"
    #         }
    #     }
    # ]
    # print(data)
    #
    token = authenticate_directus(directus_url, email, password)

    json_output = transform_payload(vcs)

    # Erstelle den Eintrag in der 'vcs' Sammlung mit einer eindeutigen ID
    created_vc = create_item_in_collection(token, directus_url, "vcs", json_output)
    print(created_vc)

    # for vc in vcs:
    #     print_vc(vc)
    #     # Your logic to handle each VerifiableCredential, e.g., save_to_cms(vc)

    return {"message": "Verifiable Credentials presented successfully!"}

# Function to print VC details - slightly adjusted for FastAPI
def print_vc(vc_instance: VerifiableCredential):
    print(f"ID: {vc_instance.id}")
    print(f"Type: {vc_instance.type}")
    print(f"Issue Date: {vc_instance.issue_date.strftime('%Y-%m-%d')}")
    print(f"Content Type: {vc_instance.content.__class__.__name__}")
    content_attrs = vc_instance.content.dict()
    for attr, value in content_attrs.items():
        print(f"    {attr}: {value}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0")