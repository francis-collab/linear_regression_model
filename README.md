# Youth Unemployment Prediction Model – Africa Focus

**Mission & Problem**  
My mission is to create sustainable jobs for Rwandan and African youth by 2035 through software engineering and predictive analytics.  
This model predicts youth unemployment rates (ages 15–24) across African countries to identify trends and key factors.  
Accurate forecasts help design targeted digital skills programs, entrepreneurship platforms, and policy interventions.  
The focus is Rwanda and the broader African context to support evidence-based job creation strategies.

## Dataset
- **Source**: World Bank Open Data – Youth unemployment rate (% of total labor force ages 15-24), ILO modeled estimate  
- **Link**: https://api.worldbank.org/v2/en/indicator/SL.UEM.1524.ZS?downloadformat=csv  
- **Scope**: Filtered to African countries + regional aggregates (Africa Eastern and Southern, Africa Western and Central, etc.)  
- **Time range**: 1991–2025 (includes projections for recent years)  
- **Records used**: ~2,000+ country-year pairs after filtering

## Models Implemented
- Linear Regression (gradient-descent style via `scipy.optimize.minimize` with L-BFGS-B)  
- Decision Tree Regressor  
- Random Forest Regressor (best performing model)

## Best Model Performance (on test set)
- **Random Forest**  
  - Test MSE: 1.7844  
  - R²: 0.9935  
- Selected because it shows the lowest generalization error and highest explanatory power on unseen African data.

## Files
- `multivariate.ipynb` → main notebook with data cleaning, visualization, feature engineering, modeling, evaluation  
- `best_youth_unemployment_model.pkl` → saved best model (RandomForestRegressor) 

## How to Use the Saved Model (example)
```python
import pickle
import pandas as pd

model = pickle.load(open('best_youth_unemployment_model.pkl', 'rb'))
new_data = pd.DataFrame({'Year': [2030], 'Country': ['Rwanda']})
prediction = model.predict(new_data)
print(f"Predicted youth unemployment rate in Rwanda 2030: {prediction[0]:.2f}%")
```

## Purpose of this work
Support data-driven decision making for youth employment programs in Rwanda and across Africa by providing reliable, country-aware forecasts of youth unemployment trends.

## Author

**Francis Mutabazi**
2026