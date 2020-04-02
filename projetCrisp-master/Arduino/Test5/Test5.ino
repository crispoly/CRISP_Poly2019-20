//RS-485 Modbus Slave 

#include<ModbusRtu.h>       //Library for using Modbus in Arduino


#define Relay1 5              //Define as 2 Relay 1 
#define Relay2 6              //Define as 5 Relay 2
#define Relay3 7              //Define as 2 Relay 3 
#define Relay4 8              //Define as 5 Relay 4
#define Relay5 9              //Define as 2 Relay 5 
#define Relay6 10              //Define as 5 Relay 6
#define Relay7 11             //Define as 2 Relay 7 
#define Relay8 12            //Define as 5 Relay 8

Modbus bus;                          //Define Object bus for class modbus 
uint16_t modbus_array[] = {0};    //Array initilized with three 0 values
                      
void setup()
{
 
  pinMode(Relay1,OUTPUT);           //Relay1 set as OUTPUT
  pinMode(Relay2,OUTPUT);           //Relay2 set as OUTPUT
  pinMode(Relay3,OUTPUT);           //Relay3 set as OUTPUT
  pinMode(Relay4,OUTPUT);           //Relay4 set as OUTPUT
  pinMode(Relay5,OUTPUT);           //Relay1 set as OUTPUT
  pinMode(Relay6,OUTPUT);           //Relay2 set as OUTPUT
  pinMode(Relay7,OUTPUT);           //Relay3 set as OUTPUT
  pinMode(Relay8,OUTPUT);           //Relay4 set as OUTPUT

    digitalWrite(Relay1,HIGH);    
    digitalWrite(Relay2,HIGH);    
    digitalWrite(Relay3,HIGH);    
    digitalWrite(Relay4,HIGH); 
    digitalWrite(Relay5,HIGH);    
    digitalWrite(Relay6,HIGH);    
    digitalWrite(Relay7,HIGH);    
    digitalWrite(Relay8,HIGH); 

    
  bus = Modbus(8,1,4);            //Modbus slave ID as 1 and 1 connected via RS-485 and 5 connected to DE & RE pin of RS-485 Module 
  bus.begin(115200);                //Modbus slave baudrate at 9600
}

void loop()

{
   bus.poll(modbus_array,sizeof(modbus_array)/sizeof(modbus_array[0]));       //Used to receive or write value from Master 

  
  if (modbus_array[0] == 0)    
  {
    digitalWrite(Relay1,HIGH);    
    digitalWrite(Relay2,HIGH);    
    digitalWrite(Relay3,HIGH);    
    digitalWrite(Relay4,HIGH);    
   
  }
  else if (modbus_array[0] == 1)
  {
    digitalWrite(Relay1,LOW);    
    digitalWrite(Relay2,LOW);    
    digitalWrite(Relay3,HIGH);    
    digitalWrite(Relay4,HIGH);    
  } 

 else if (modbus_array[0] == 2)    
  {
    digitalWrite(Relay1,HIGH);    
    digitalWrite(Relay2,HIGH);    
    digitalWrite(Relay3,HIGH);    
    digitalWrite(Relay4,HIGH);    
    
  }
  else if (modbus_array[0] == 3)
  {
    digitalWrite(Relay1,HIGH);    
    digitalWrite(Relay2,HIGH);    
    digitalWrite(Relay3,LOW);    
    digitalWrite(Relay4,LOW);    
    
  }
  

}
