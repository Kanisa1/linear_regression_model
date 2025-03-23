from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, conint
import numpy as np
import joblib
import uvicorn

# Load the trained model
model = joblib.load('best_severity_model.pkl')

app = FastAPI(title="COVID-19 Severity Prediction API")

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust as needed for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define the Pydantic model with constraints
class PatientData(BaseModel):
    Fever: conint(ge=0, le=1)
    Tiredness: conint(ge=0, le=1)
    Dry_Cough: conint(ge=0, le=1)
    Difficulty_in_Breathing: conint(ge=0, le=1)
    Sore_Throat: conint(ge=0, le=1)
    None_Symptom: conint(ge=0, le=1)
    Pains: conint(ge=0, le=1)
    Nasal_Congestion: conint(ge=0, le=1)
    Runny_Nose: conint(ge=0, le=1)
    Diarrhea: conint(ge=0, le=1)
    None_Experiencing: conint(ge=0, le=1)

    Age_0_9: conint(ge=0, le=1)
    Age_10_19: conint(ge=0, le=1)
    Age_20_24: conint(ge=0, le=1)
    Age_25_59: conint(ge=0, le=1)
    Age_60plus: conint(ge=0, le=1)

    Gender_Female: conint(ge=0, le=1)
    Gender_Male: conint(ge=0, le=1)
    Gender_Transgender: conint(ge=0, le=1)

    Contact_Dont_Know: conint(ge=0, le=1)
    Contact_No: conint(ge=0, le=1)
    Contact_Yes: conint(ge=0, le=1)

@app.post("/predict")
async def predict_severity(data: PatientData):
    try:
        # Arrange the input in the correct order
        input_features = np.array([[
            data.Fever, data.Tiredness, data.Dry_Cough, data.Difficulty_in_Breathing,
            data.Sore_Throat, data.None_Symptom, data.Pains, data.Nasal_Congestion,
            data.Runny_Nose, data.Diarrhea, data.None_Experiencing,
            data.Age_0_9, data.Age_10_19, data.Age_20_24, data.Age_25_59, data.Age_60plus,
            data.Gender_Female, data.Gender_Male, data.Gender_Transgender,
            data.Contact_Dont_Know, data.Contact_No, data.Contact_Yes
        ]])

        # Predict using the best model
        prediction = model.predict(input_features)

        # Interpret the prediction
        if prediction[0] <= 1.5:
            severity = "Mild"
        elif 1.5 < prediction[0] <= 2.5:
            severity = "Moderate"
        else:
            severity = "Severe"

        return {"Predicted Severity Score": prediction[0], "Severity Level": severity}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
