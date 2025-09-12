Model bundle for Odisha yield prediction
Files included:
- yield_rf_model.pkl   : trained RandomForest model and label encoders (joblib)
- odisha_ml_ready.csv  : example training schema (features and types)
- yield_test_predictions.csv : test predictions & residuals (quality check)
- inference.py         : example inference script (load model, preprocess, predict)

Usage:
1) Place files in same directory on backend.
2) Install dependencies: pip install scikit-learn pandas joblib
3) Run inference.py or import its predict() function from your backend.
Notes:
- Encoders were saved with the model; categorical columns expected: district, crop, season, soil_texture_class.
- If backend receives new categorical values unseen in training, label encoder will raise an error.
- The model predicts 'yield_tonnes_per_hectare'.
