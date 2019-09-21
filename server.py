import base64
import requests
import json
import matplotlib.pyplot as plt
import base64
from flask import Flask, jsonify, request, render_template

# import numpy as np
# import pandas as pd
# import matplotlib.pyplot as plt
# from sklearn.model_selection import train_test_split
# from sklearn.datasets import load_boston
# from sklearn.metrics import mean_squared_error, r2_score
# from sklearn.linear_model import LinearRegression

heightValues = list()
lightValues = list()
tempValues = list()
humidityValues = list()
soilMoistureValues = list()
healthScoreValues = list()

def createGraph(varName, values):
    x = []
    plt.clf()

    if len(values) < 50:
        y = values
    else:
        y = values[-50:]

    for i in range(0, len(y)):
        x.append(i)

    # plotting the points
    plt.plot(x, y, color = 'red')

    axes = plt.gca()
    axes.set_ylim([0, 100])

    # naming the x axis
    plt.xlabel('Time (seconds)')
    # naming the y axis
    plt.ylabel(varName)

    # giving a title to my graph
    plt.title(varName + ' vs Time (seconds)')

    # function to show the plot
    plt.savefig("values.png", bbox_inches="tight")

    with open("values.png", "rb") as imageFile:
        imageStr = base64.b64encode(imageFile.read())
    return str(imageStr)[2:-1]


def returnTotalScore(h):
    height = float(h[0])
    soilMoisture = float(h[1])
    light = float(h[2])
    temp = float(h[3])
    humidity = float(h[4])

    heightScore = 100 - abs(26-height) * 4
    soilScore = 100 - abs(40-soilMoisture)
    lightScore = 100 - abs(80-light)
    tempScore = 100 - abs(21-temp) * 5
    humidityScore = 100 - abs(50-humidity)

    score = (heightScore * 2 + soilScore * 3 + lightScore +
             tempScore + humidityScore)/8
    x = int(score)
    if(x < 0):
        x = 0
    return x

app = Flask(__name__)
# Create a URL route in our application for "/"
@app.route('/api', methods=['POST'])
def addOne():
    # request.get_data()
  #  print(request.data['data'].decode(encoding='UTF-8'))
   # return jsonify(reqdata_list = data_list.replace("\\n", "")
    request.get_data()
    # matter, humidity, temp
    print(request.data)
    data_list = request.data.decode("utf-8")
    data_list = data_list.replace("\\r", "")
    data_list = data_list.replace("\\n", "")
    data_list = data_list.replace("{", "")
    data_list = data_list.replace("[", "")
    data_list = data_list.replace("]", "")
    data_list = data_list.replace("}", "")
    data_list = data_list.replace("\n", "")
    data_list = data_list.replace(" ", "")
    data_list = data_list.replace("\"", "")
    data_list = data_list.replace("\\.", "")
    data_list = data_list.split(',')
    if(len(data_list) == 5):
        height = float(data_list[0])
        light = float(data_list[2])
        temp = float(data_list[3])
        humidity = float(data_list[4])
        soilMoisture = float(data_list[1])
        heightValues.append(height)
        lightValues.append(light)
        tempValues.append(temp)
        humidityValues.append(humidity)
        soilMoistureValues.append(soilMoisture)
        healthScoreValues.append(returnTotalScore(data_list))
        pumpVal = 1
        if(soilMoisture >= 40):
            pumpVal = 0
        return (str(returnTotalScore(data_list)) + "," + str(pumpVal))
    elif(data_list[0] == "health"):
        return (str(createGraph("Health", healthScoreValues)))
    elif(data_list[0] == "healthVal"):
        if(len(healthScoreValues) == 0):
            return "N/A"
        return (str(healthScoreValues[len(healthScoreValues)-1]))
    elif(data_list[0] == "height"):
        return (str(createGraph("Height (centimeters)", heightValues)))
    elif(data_list[0] == "light"):
        return (str(createGraph("Light (%)", lightValues)))
    elif(data_list[0] == "temp"):
        print(tempValues)
        return (str(createGraph("Temperature (degrees Celsius)", tempValues)))
    elif(data_list[0] == "humidity"):
        return (str(createGraph("Relative Humidity (%)", humidityValues)))
    elif(data_list[0] == "tempValues"):
        return (str(tempValues[0]))
    elif(data_list[0] == "soil"):
        return (str(createGraph("Soil Moisture (%)", soilMoistureValues)))
    elif(data_list[0] == 'water'):
        a = 40-soilMoistureValues
        if a >= 0:
            return str(a)
        else:
            return "0"
    else:
        return "Invalid request"


if __name__ == "__main__":
    app.run(debug=True)
