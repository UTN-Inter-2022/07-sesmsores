
 
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
  model = loadShape("phone.obj");
  shapeMode(CENTER);
  
  
  /* start oscP5, escucha los mensajes en el puerto 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* esto se usaría al ENVIAR mensajes como parámetro
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}


void draw() {
  

  lights();
  
  
  background(255,128,64);  
  

  
  translate(width/2,height/2,0);
  

  rotateX(radians(valorX));
  rotateY(radians(valorY));
  rotateZ(radians(valorZ));
  
  scale(40);
  shape(model);

}


// mensje recibido
void oscEvent(OscMessage theOscMessage) {
  print(theOscMessage.addrPattern());
  println();
  if (theOscMessage.addrPattern().equals("/utn/mfp/1/scope1")){
   if(theOscMessage.checkTypetag("fff")) {
      float OSCvalue0 = theOscMessage.get(0).floatValue(); 
      float OSCvalue1 = theOscMessage.get(1).floatValue();
      float OSCvalue2 = theOscMessage.get(2).floatValue();
      println(" values: "+OSCvalue0);
      println(" values: "+OSCvalue1);
      println(" values: "+OSCvalue2);
      valorZ=OSCvalue0*100;
      valorX=OSCvalue1*100;
      valorY=OSCvalue2*100;
      print();
   }
  }

}
