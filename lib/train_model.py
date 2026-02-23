import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report

# Load dataset
df = pd.read_csv("lib/waste_dataset.csv")


# Encode categorical features
le_area = LabelEncoder()
le_access = LabelEncoder()
le_severity = LabelEncoder()
le_priority = LabelEncoder()

df["area_type"] = le_area.fit_transform(df["area_type"])
df["road_accessibility"] = le_access.fit_transform(df["road_accessibility"])
df["severity"] = le_severity.fit_transform(df["severity"])
df["priority"] = le_priority.fit_transform(df["priority"])

# Features
X = df[[
    "latitude",
    "longitude",
    "area_type",
    "population",
    "nearby_houses",
    "road_accessibility"
]]

# Targets
y_severity = df["severity"]
y_priority = df["priority"]

# Split data
X_train, X_test, y_train_s, y_test_s = train_test_split(
    X, y_severity, test_size=0.2, random_state=42
)

X_train2, X_test2, y_train_p, y_test_p = train_test_split(
    X, y_priority, test_size=0.2, random_state=42
)

# Train models
severity_model = RandomForestClassifier()
priority_model = RandomForestClassifier()

severity_model.fit(X_train, y_train_s)
priority_model.fit(X_train2, y_train_p)

# Predictions
pred_s = severity_model.predict(X_test)
pred_p = priority_model.predict(X_test2)

print("Severity Model Report:")
print(classification_report(y_test_s, pred_s))

print("Priority Model Report:")
print(classification_report(y_test_p, pred_p))
