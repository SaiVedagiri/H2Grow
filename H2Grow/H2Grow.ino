#include <dht.h>
#include <LiquidCrystal.h>
LiquidCrystal lcd(2, 3, 4, 5, 6, 7);
dht DHT;


// defines pins numbers
const int trigPin = 11;
const int echoPin = 10;
const int soilMoisture = A2;
const int pump = A0;
const int tempHum = 8;
const int light = A3;
const int button = 25;

const int red_light_pin = 35;
const int green_light_pin = 33;
const int blue_light_pin = 31;
int timer = 0;
int c;
int d;
String f = "";

bool buttonState = 0;

// defines variables
long duration;
int distance;
void RGB_color(int red_light_value, int green_light_value, int blue_light_value)
 {
  analogWrite(red_light_pin, red_light_value);
  analogWrite(green_light_pin, green_light_value);
  analogWrite(blue_light_pin, blue_light_value);
 }
 
void setup() {
RGB_color(255, 0, 0);
lcd.begin(16, 2);
pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
pinMode(echoPin, INPUT); // Sets the echoPin as an Input
Serial.begin(9600); // Starts the serial communication
Serial3.begin(9600);
int chk = DHT.read11(8);
c = DHT.temperature;
d = DHT.humidity;

while (Serial3.available() == 0)
{
  
}
RGB_color(0, 0, 255);
}

void loop() {
  
lcd.setCursor(0, 0);
// Clears the trigPin
digitalWrite(trigPin, LOW);
delayMicroseconds(2);
// Sets the trigPin on HIGH state for 10 micro seconds
digitalWrite(trigPin, HIGH);
delayMicroseconds(10);
digitalWrite(trigPin, LOW);
// Reads the echoPin, returns the sound wave travel time in microseconds
duration = pulseIn(echoPin, HIGH);
// Calculating the distance
distance= duration*0.034/2;
distance = 28-distance;
if (abs(distance) > 100)
  distance = 27;
if (distance<=0)
  distance = 0;
// Prints the distance on the Serial Monitor
String s = "";
s+= distance;
s+= ",";
int a = analogRead(soilMoisture);
a /= 20;
s+=a;
s += ",";
int b = analogRead(light);
b = b/10;
b = 100-b;
s += b;
s += ",";

 c = DHT.temperature;
 d = DHT.humidity;
s += c;
s += ",";
s += d;


Serial.println(s);
Serial3.println(s);

  if(Serial3.available()>0)
  {
   f = Serial3.readString();
  }
  
  
  int z = f.indexOf(",");
  String q = f.substring(0, z);
  String motor = f.substring(z+1);
  // pump motor thing
  lcd.clear();
  lcd.print("Health Score: ");

  lcd.print(q);
  
  lcd.setCursor(0, 1);

  lcd.print("Height: ");
  lcd.print(distance);
  lcd.print(" cm");
  
  
  

delay(1000);
}
