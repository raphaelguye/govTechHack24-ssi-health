from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime
from typing import List, Union

app = FastAPI()

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

# Route to handle presentation
@app.post('/present')
def presentation(vcs: List[VerifiableCredential]):
    for vc in vcs:
        print_vc(vc)
        # Your logic to handle each VerifiableCredential, e.g., save_to_cms(vc)

    return {"message": "Verifiable Credentials erfolgreich erhalten und verarbeitet"}

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