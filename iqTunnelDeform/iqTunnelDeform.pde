PShader toon;

// https://www.iquilezles.org/www/articles/deform/deform.htm
PImage img;
void setup() {
  size(1280, 720, P3D);
  noStroke();
  fill(204);
  img = loadImage("gselfieOil.JPG");
  toon = loadShader("iqSquareTunnel.glsl");
  
}

void draw() {
  toon.set("iResolution", float(width), float(height));
//  toon.set("u_mouse", float(mouseX), float(mouseY));
  toon.set("iTime", millis() / 1000.0);
  
  shader(toon);
  rect(0,0,width,height);
  image(img,0,0);
  //saveFrame();
}
