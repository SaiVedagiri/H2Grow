import base64
import requests, json
import matplotlib.pyplot as plt
import base64
import pyrebase
from flask import Flask, jsonify, request, render_template
import random as r

config = {
  "apiKey": "AIzaSyCMIKySyTQfzDtZKfdp9bAFR-4mx44nvb8",
  "authDomain": "projectId.firebaseapp.com",
  "databaseURL": "https://breathable-f5a44.firebaseio.com",
  "storageBucket": "projectId.appspot.com"
}

firebase = pyrebase.initialize_app(config)


db = firebase.database()


# Enter your API key here 
api_key = "3829e3108d626e59f6056fe0ae9d7886"
def getData():
    # base_url variable to store url 
    base_url = "http://api.openweathermap.org/data/2.5/weather?"
      
    # Give city name 
    city_name = "Brooklyn" 
      
    # complete_url variable to store 
    # complete url address 
    complete_url = base_url + "appid=" + api_key + "&q=" + city_name 
      
    # get method of requests module 
    # return response object 
    response = requests.get(complete_url) 
      
    # json method of response object  
    # convert json format data into 
    # python format data 
    x = response.json()
    count = 1
    temp = 0
    for i in x["weather"]:
        description = (i["description"])
    for i in x["main"]:
        data = x["main"][i]
        if count == 1:
            temp = data
            count+=1
        if count == 2:
            airPressure = data
            count+=1
        if count==3:
            humidity = data
            count+=1
        if count == 4:
            minimumTemp = data
            count+=1
        if count==5:
            maximumTemp = data
            count+=1
        localInfo = []
        localInfo.append(temp)
        localInfo.append(airPressure)
        localInfo.append(humidity)
        localInfo.append(minimumTemp)
        localInfo.append(maximumTemp)
        return localInfo
def createGraph(temperatures):
    x = [1,2,3, 4, 5, 6, 7, 8, 9, 10] 
    # corresponding y axis values 
    y = temperatures
      
    # plotting the points  
    plt.plot(x, y) 
      
    # naming the x axis 
    plt.xlabel('Time') 
    # naming the y axis 
    plt.ylabel('Temperature') 
      
    # giving a title to my graph 
    plt.title('Temperature Vs Time') 

    # function to show the plot 
    plt.savefig("temperature.png", bbox_inches = "tight")

    with open("temperature.png", "rb") as imageFile:
        imageStr = base64.b64encode(imageFile.read())
        print (str)
    return str
def returnTotalScore(insideInfo):
    h = getData()
    h[0] = 70
    temp = (h[0])
    #temp = h[0] * (9/5) - 459.67
    #print(temp)
    optimalTemp = 60
    tempScore = 100 - (temp - optimalTemp)
    h[1] = 1030
    
    airPressureScore = 100 - (h[1] - 1000)/7
    h[2] = 67
   
    humidityScore = abs(100 - (h[2] - 50))
    minimumTemp = h[3]
    maximumTemp = h[4]
    airQualityScore = abs(100 - (insideInfo[0] * 10))
    insideHumidityScore = abs(100 - abs((insideInfo[1] - 50)))
    insideTempScore = insideInfo[2]
    print(tempScore)
    print(airPressureScore)
    print(humidityScore)
    print(airQualityScore)
    print(insideHumidityScore)
    print(insideTempScore)
    db.update({"airScore": str(airQualityScore)})
    db.update({"humidityScore": str(humidityScore)})
    db.update({"temperatureScore": str(tempScore)})
    score = (tempScore + airPressureScore + humidityScore + airQualityScore + insideHumidityScore + insideTempScore)/6
    x = int(100-score)
    db.update({"severityScore": str(x)})
    return x
print (returnTotalScore([1.5, 45, 73]))

# Cead the swagger.yml file to configure the endpoints

#answer = ''
app = Flask(__name__)
# Create a URL route in our application for "/"
@app.route('/api', methods=['POST'])
def addOne():
    #request.get_data()
  #  print(request.data['data'].decode(encoding='UTF-8'))
   # return jsonify(request.data.decode(encoding='UTF-8').['data'])
    request.get_data()
    #matter, humidity, temp
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
    for i in range(len(data_list)):
        data_list[i]=float(data_list[i])
    matter = list()
    humidity = list()
    temp = list()
    for i in range(10):
        matter.append(r.randint(75, 125)/100.0)
        humidity.append(r.randint(35,55))
        temp.append(r.randint(70,75))
    returnTotalScore(data_list)
    return str(data_list[1])
    #answer = value
    
    return 'sup'
##@app.route('/hello')
##def workplz():
##    print(answer)
##    return render_template('home.html', value=answer)
if __name__ == "__main__":
    app.run(debug=True)
