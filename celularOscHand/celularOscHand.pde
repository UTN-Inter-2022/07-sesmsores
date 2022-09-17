
 
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
  print(theOscMessage.typetag());
  if (theOscMessage.addrPattern().equals("/utn/mfp/pos")){
   if(theOscMessage.checkTypetag("i")) {
      float OSCvalue0 = theOscMessage.get(0).intValue(); 
      println(" values: "+OSCvalue0);
      valorX=OSCvalue0*10;
      print();
   }
  }

}
