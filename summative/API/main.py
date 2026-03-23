from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, field_validator
import pickle
import pandas as pd
from io import BytesIO, StringIO
import csv

app = FastAPI(
    title="African Youth Unemployment Prediction API",
    description="Predicts youth unemployment rate (15-24) for African countries",
    version="1.0"
)

# CORS configuration 
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost",
        "http://localhost:8080",
        "http://127.0.0.1:8080",
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["Content-Type", "Authorization", "Accept"],
)

# Load the trained pipeline (RandomForest from Task 1)
with open("best_youth_unemployment_model.pkl", "rb") as f:
    model = pickle.load(f)

# Extract valid countries from the fitted OneHotEncoder
preprocessor = model.named_steps["prep"]
cat_transformer = preprocessor.named_transformers_["cat"]
VALID_COUNTRIES = cat_transformer.categories_[0].tolist()

class PredictRequest(BaseModel):
    Year: float = Field(..., ge=1990.0, le=2040.0)
    Country: str = Field(...)

    @field_validator("Country")
    @classmethod
    def country_must_be_trained(cls, v: str) -> str:
        if v not in VALID_COUNTRIES:
            raise ValueError(
                f"Invalid country. Must be one of: {', '.join(VALID_COUNTRIES[:8])} ..."
            )
        return v

class PredictResponse(BaseModel):
    predicted_rate: float
    year: float
    country: str

@app.get("/")
def read_root():
    return {"message": "API is running. Use /docs for Swagger UI."}

@app.post("/predict", response_model=PredictResponse)
def predict(data: PredictRequest):
    try:
        input_df = pd.DataFrame([data.model_dump()])
        prediction = model.predict(input_df)[0]
        return PredictResponse(
            predicted_rate=round(float(prediction), 2),
            year=data.Year,
            country=data.Country
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/retrain")
async def retrain(file: UploadFile = File(...)):
    if not file.filename.lower().endswith((".csv", ".json")):
        raise HTTPException(status_code=400, detail="Only CSV or JSON files allowed")

    content = await file.read()

    try:
        if file.filename.lower().endswith(".csv"):
            df_new = pd.read_csv(BytesIO(content))
        else:
            df_new = pd.read_json(BytesIO(content))

        # Minimal validation
        required = {"Country", "Year", "YouthUnemploymentRate"}
        if not required.issubset(df_new.columns):
            raise ValueError("File must contain columns: Country, Year, YouthUnemploymentRate")

        row_count = len(df_new)
        return {
            "status": "triggered",
            "message": f"Received file '{file.filename}' with {row_count} rows. Model retraining triggered.",
            "note": "In full production this would refit & save the updated model."
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"File processing failed: {str(e)}")