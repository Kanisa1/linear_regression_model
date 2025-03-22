# Import necessary libraries
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, confloat, conint
import uvicorn
import pandas as pd
import joblib

# Load the trained model
model = joblib.load('models/best_model.pkl')

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
    # Add more features as necessary

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
    import os
    uvicorn.run("app:app", host="0.0.0.0", port=port)
