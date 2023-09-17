  
 
import oscP5.*;
import netP5.*;
import processing.sound.*;
SoundFile file;


OscP5 oscP5;
NetAddress myRemoteLocation;

float rate;
float go=0;


void setup() {
  size(800,600);
  
  
  /* start oscP5, escucha los mensajes en el puerto 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* esto se usaría al ENVIAR mensajes como parámetro
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  
  background(255);

  file = new SoundFile(this, "sample4.mp3");
  file.play();
  rate=1;
}      
  


void draw() {
  
 
    file.rate(rate);
    if (go>0){
      file.jump(go);
      go=0;
    }
  

}


// mensje recibido
void oscEvent(OscMessage theOscMessage) {
  //print(theOscMessage.addrPattern());
  //println();
  if (theOscMessage.addrPattern().equals("/utn/mfpsound/1/keyboard1")){

      int OSCvalue0 = theOscMessage.get(0).intValue(); 
      int OSCvalue1 = theOscMessage.get(1).intValue();
      int OSCvalue2 = theOscMessage.get(2).intValue();
      println(" presionada: "+OSCvalue0);
      println(" nota (0 a 127): "+OSCvalue1);
      println(" velocidad (0 a 127): "+OSCvalue2);

      rate=norm(OSCvalue2,0,127)*1.5+1;
      
      if (OSCvalue1==29) {
        go=2;
      }
      
      

      //print();
   
  }

}
