# HackHSNTest

## Inspiration
Two of our team members have often visited India and noticed that there is a significant lack of water as compared to western countries such as the United States. Much of this water gets wasted when people try to grow plants, and provide their plant too much water. Our project aims to combat this issue by providing an easy to use interface to demonstrate the ideal amount of water, temperature, light, and other environmental factors such that the plant can prosper without using too much water.
## What it does
The product takes in a variety of data from sensors, including the temperature and humidity of the surrounding air, height of the plant, soil moisture, and light intensity. This data is sent to the back-end, which uses machine learning to create a weighted average of a final Health Score. The back-end will also track the previous 10 values for all the sensor data, and send a graph of these points to the front-end. The front-end (an iOS app built using Swift) has multiple tabs that display graphs of the different environmental factors. The user can view different values such as health score and amount to water. 
## How we built it
To build the project, we divided into three components. The first component was the hardware. The foundation was built using cardboard and paper, such that it would maintain the weight of the sensors and Arduino. After connecting the Arduinos to multiple breadboards with sensors, the code was uploaded, which would keep track of the varying values. The next component was the iOS application. This was built using Swift on XCode. The Arduino sent the values to the application, which would send a post request to a server. The final component was built in Python, which connected to a Heroku server where it was set up as an API. This code had the algorithms that calculated the scores and created the graphs. After it received the post request, the server sends a response with the graphs and scores.
## Challenges we ran into
The wiring for the Arduino was extremely difficult to do, as there were many different sensors and wires, which had to be connected to the same Arduino. Additionally, since there was a lot of current running through the Arduino (to accommodate the sensors), some of the component (e.g. transistors) were fried. At first, this was an extremely unexpected issue, which took along time to figure out.
## Accomplishments that we're proud of
It works!
## What we learned
While coding the project, we learned how to connect an Arduino to an application, through Bluetooth; set up a cloud server that can run Python code, which can be accessed anywhere; and multivariate polynomial regression, which can help define ideal weighted averages. We learned a great deal in order to make this project come together.
## What's next for H2Grow
The next step would be for the product to be fully automated. This means that as the scores change, the environment around it would be altered to match ideal conditions. Additionally, the pumps did not work as intended. Although we are currently unsure of why it was not working, it may be because one of the circuits had been fried.
