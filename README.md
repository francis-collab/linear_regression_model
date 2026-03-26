# Youth Unemployment Prediction Model – Africa Focus

**Mission & Problem**  
My mission is to create sustainable jobs for Rwandan and African youth by 2035 through software engineering and predictive analytics.  
This model predicts youth unemployment rates (ages 15–24) across African countries to identify trends and key factors.  
Accurate forecasts help design targeted digital skills programs, entrepreneurship platforms, and policy interventions.  
The focus is Rwanda and the broader African context to support evidence-based job creation strategies.

## Task 1: Linear Regression Model

**Dataset**  
- **Source**: World Bank Open Data – Youth unemployment rate (% of total labor force ages 15-24), ILO modeled estimate  
- **Link**: https://api.worldbank.org/v2/en/indicator/SL.UEM.1524.ZS?downloadformat=csv  
- **Scope**: Filtered to African countries and regional aggregates  
- **Time range**: 1991–2025  
- **Records used**: ~2,000+ country-year pairs after filtering

**Models Implemented**  
- Linear Regression (optimized with gradient descent using `scipy.optimize.minimize` L-BFGS-B)  
- Decision Tree Regressor  
- Random Forest Regressor (**best performing model**)

**Best Model Performance (Test Set)**  
- **Random Forest**  
  - Test MSE: 1.7844  
  - R²: 0.9935  

Selected because it achieved the lowest generalization error and highest explanatory power on African youth unemployment data.

**Files**  
- `summative/linear_regression/multivariate.ipynb` → Complete notebook with data cleaning, visualizations, feature engineering, modeling, and evaluation  
- `best_youth_unemployment_model.pkl` → Saved best model (RandomForestRegressor)

## Task 2: FastAPI Backend

**Live API Endpoint**  
Base URL: https://linear-regression-model-fg0z.onrender.com  
Swagger UI: https://linear-regression-model-fg0z.onrender.com/docs

**Features Implemented**  
- POST `/predict` – Predicts youth unemployment rate with Pydantic validation (Year range 1990–2040 + country validation)  
- POST `/retrain` – Triggers model retraining when new data (CSV/JSON) is uploaded  
- CORS middleware configured with explicit origins, methods (GET, POST, OPTIONS), headers, and credentials  
- Deployed on Render with auto-deploy enabled

**Local Testing**  
Tested GET `/`, POST `/predict` (valid + invalid inputs), and POST `/retrain` before deployment.

## Task 3: Flutter Mobile App

**Features**  
- Single clean page as required  
- Two input fields: Year and Country  
- "Predict Unemployment Rate" button  
- Real-time result display with success/error cards  
- Visually appealing design with mission-relevant icons (Africa 🌍 + Rwanda 🇷🇼), gradient background, and professional color scheme  

**How to Run the Flutter App**  
1. Clone the repository  
2. `cd linear_regression_model/summative/FlutterApp`  
3. `flutter pub get`  
4. `flutter run`  
5. Enter Year and Country → Tap "Predict Unemployment Rate"

## Task 4: Video Demo

**YouTube Video Link**  
https://youtu.be/ADLKdrZfOkE  

(5-minute demo showing:  
- Task 1 notebook + model performance explanation    
- Live Swagger UI testing (GET, POST /predict, POST /retrain) 
- Flutter mobile app making real predictions  
- Answers to all required questions: loss analysis, hyperparameters, new data handling, and CORS configuration)

## Repository Structure

```
linear_regression_model/
├── summative/
│   ├── linear_regression/
│   │   └── multivariate.ipynb
│   ├── API/
│   │   ├── main.py
│   │   ├── requirements.txt
│   │   └── best_youth_unemployment_model.pkl
│   └── youth_unemployment_rate_prediction_app/
│       ├── lib/
│       │   ├── main.dart
│       │   └── prediction_screen.dart
│       └── pubspec.yaml
└── README.md
```

## Purpose of this Work

This project demonstrates a complete end-to-end machine learning solution — from data analysis and model building to API deployment and mobile application — all aligned with my mission of creating data-driven solutions for youth employment in Rwanda and Africa.

---

**Author**: Francis Mutabazi  
**Year**: 2026

---