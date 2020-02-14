char letter;
int s1= 4;
int read1 =0;
void setup() {

pinMode(s1,OUTPUT);
pinMode(LED_BUILTIN, OUTPUT);
Serial.begin(9600);

}

void loop() {

  read1 = digitalRead(s1);
  if (Serial.available() > 0)
  {

    //Lecture serial
    letter = Serial.read();
    
    //Lecture switch
   
    if (letter == '1') //Sil voit un 1; qu'on le call
    {
      
    //Serial.write(0x02);                          //Etat des capteurs

      digitalWrite(LED_BUILTIN,HIGH);
      delay(3000);
      digitalWrite(LED_BUILTIN,LOW);      
    }

  }

    

}
