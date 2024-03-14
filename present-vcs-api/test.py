import requests
from datetime import datetime

# Endpoint you want to test
url = 'http://127.0.0.1:8000/present'

# Correctly formatted sample data as a direct list of VerifiableCredential
data = [
    {
        "id": "vc-1",
        "type": "AllergyRecord",
        "issue_date": datetime.now().isoformat(),
        "content": {
            "allergy_code": "A001",
            "allergy_description": "Pollen Allergy",
            "reaction_code": "R102",
            "severity": "High"
        }
    },
    {
        "id": "vc-2",
        "type": "MedicationRecord",
        "issue_date": datetime.now().isoformat(),
        "content": {
            "medication_code": "M002",
            "medication_name": "Aspirin",
            "dosage_instruction": "Take one tablet daily"
        }
    }
]

# Sending a POST request to the API endpoint with the correctly formatted payload
response = requests.post(url, json=data)

# Printing the response from the server
print(f"Status Code: {response.status_code}")
print(f"Response Body: {response.json()}")
