  
 
import oscP5.*;
import netP5.*;
import peasy.PeasyCam;


OscP5 oscP5;
NetAddress myRemoteLocation;


float valorX,valorY,valorZ = 0;

PShape model;

void setup() {
  size(800,600,P3D);
  frameRate(25);
  
  
  /* start oscP5, escucha los mensajes en el puerto 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* esto se usaría al ENVIAR mensajes como parámetro
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  lights();
}


void draw() {
  
 background(0,0,0);
 
 translate(width/2+valorX,height/2+valorY,0);
 
 fill(128,56,34);
 
 sphere(56+valorZ);
  

}


// mensje recibido
void oscEvent(OscMessage theOscMessage) {
  //print(theOscMessage.addrPattern());
  println();
  if (theOscMessage.addrPattern().equals("/utn/mfpac/1/scope1")){
   if(theOscMessage.checkTypetag("fff")) {
      float OSCvalue0 = theOscMessage.get(0).floatValue(); 
      float OSCvalue1 = theOscMessage.get(1).floatValue();
      float OSCvalue2 = theOscMessage.get(2).floatValue();
      println(" values x: "+OSCvalue0);
      println(" values y: "+OSCvalue1);
      println(" values z: "+OSCvalue2);
      valorZ=OSCvalue0*100;
      valorX=OSCvalue1*100;
      valorY=OSCvalue2*100;
      print();
   }
  }

}
