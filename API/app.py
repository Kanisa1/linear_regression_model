from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, conint
import pandas as pd
import joblib
import os

# Load the trained model
model_path = os.path.join(os.path.dirname(__file__), "models/best_model.pkl")
model = joblib.load(model_path)

# Initialize FastAPI app
app = FastAPI()

# Root endpoint
@app.get("/")
def read_root():
    return {"message": "Welcome to the FastAPI API!"}

# Define the input data model using Pydantic
class PredictionInput(BaseModel):
    itching: conint(ge=0, le=1)
    skin_rash: conint(ge=0, le=1)
    nodal_skin_eruptions: conint(ge=0, le=1)
    continuous_sneezing: conint(ge=0, le=1)
    shivering: conint(ge=0, le=1)
    chills: conint(ge=0, le=1)
    joint_pain: conint(ge=0, le=1)
    stomach_pain: conint(ge=0, le=1)
    acidity: conint(ge=0, le=1)
    ulcers_on_tongue: conint(ge=0, le=1)
    abdominal_pain: conint(ge=0, le=1)  # Added missing feature
    abnormal_menstruation: conint(ge=0, le=1)  # Added missing feature
    acute_liver_failure: conint(ge=0, le=1)  # Added missing feature
    altered_sensorium: conint(ge=0, le=1)  # Added missing feature
    anxiety: conint(ge=0, le=1)  # Added missing feature

    class Config:
        extra = "ignore"  # Allow extra fields without error

# Define the prediction endpoint
@app.post('/predict')
def predict(input_data: PredictionInput):
    try:
        # Convert input data to DataFrame
        input_dict = input_data.dict()
        input_df = pd.DataFrame([input_dict])

        # Make prediction
        prediction = model.predict(input_df)
        return {"prediction": prediction[0]}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

# Run the application
if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get('PORT', 8000))
    uvicorn.run("app:app", host="0.0.0.0", port=port)
