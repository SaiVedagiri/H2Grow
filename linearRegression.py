import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.datasets import load_boston
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.linear_model import LinearRegression

def getCSVData(fileName):
    return pd.read_csv(fileName)

data = getCSVData('data1.csv')

lin_reg_mod = LinearRegression()


data = pd.DataFrame(getCSVData('data1.csv'))

lin_reg_mod = LinearRegression()

X = list(data['Humidity'])
y = list(data['Score'])


X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state=9)

lin_reg_mod.fit(X_train, y_train)

pred = lin_reg_mod.predict(X_test)

test_set_rmse = (np.sqrt(mean_squared_error(y_test, pred)))

test_set_r2 = r2_score(y_test, pred)

print (lin_reg_mod.coef_)


vals = ['Height', 'Light', 'Temperature', 'Humidity', 'Soil Moisture']
valsScores = ['HeightScore', 'LightScore', 'TemperatureScore', 'HumidityScore', 'SoilMoistureScore']
X = list(data['Humidity'])
y = list(data['HeightScore'])

degree = 2
poly_fit = np.poly1d(np.polyfit(X, y, degree))

print (poly_fit)

xx = np.linspace(0, 26, 100)
plt.plot(xx, poly_fit(xx), c='r',linestyle='-')
plt.title('Polynomial')
plt.xlabel('X')
plt.ylabel('Y')
plt.axis([0, 25, 0, 100])
plt.grid(True)
plt.scatter(X, y)
plt.show()

print( poly_fit(12) )