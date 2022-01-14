  PShader toon;

// https://www.iquilezles.org/www/articles/deform/deform.htm
PImage img;
void setup() {
  size(1280, 720, P3D);
  noStroke();
  fill(204);
  //img = loadImage("seaShellFoam_mirror720.jpg");
  toon = loadShader("sdfMasks.glsl");
}

void draw() {
  toon.set("iResolution", float(width), float(height));
//  toon.set("u_mouse", float(mouseX), float(mouseY));
  float tmilli = millis() / 1000.0;
  toon.set("iTime", tmilli);
  //println(frameCount + " :: " + cos(0.2*tmilli));
  
  
  shader(toon);
  rect(0,0,width,height);
  //image(img,0,0);
  //saveFrame();
}
