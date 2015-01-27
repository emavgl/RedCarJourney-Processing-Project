#include <SoftwareSerial.h>
const int ledPin =  12;
int ledState = LOW;

//I use digital pin to communicate with bluetooth.
//In this way Arduino can recive Data also from Computer.
SoftwareSerial mySerial(10, 11); // RX, TX
int myLeds[] = {4, 5, 6, 12};

void setup() {
  mySerial.begin(9600);
  Serial.begin(9600);
  pinMode(12, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT); 
  pinMode(4, OUTPUT);    
}

void loop()
{   
    //Data From PC (Processing)
    if (Serial.available())
    {
      //Get task from Serial
      int currentLifes = Serial.read();
      for(int i=0; i<4; i++){
        if(i<currentLifes){
          //accendi
          digitalWrite(myLeds[i], HIGH);
        } else {
          //spegni
          digitalWrite(myLeds[i], LOW);
        }
      }

        
     }

  //Data from Bluetooth
   while (mySerial.available() > 0) {
     int mNumber = mySerial.read();
     Serial.write(mNumber);
     //Serial.println(mNumber);
   }
}
