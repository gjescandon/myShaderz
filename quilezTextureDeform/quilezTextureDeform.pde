PShader toon;

// https://www.iquilezles.org/www/articles/deform/deform.htm
PImage img;
void setup() {
  size(1280, 720, P3D);
  noStroke();
  fill(204);
  //img = loadImage("seaShellFoam_mirror720.jpg");
  //img = loadImage("gselfieOil.JPG");
  //img = loadImage("face16.jpg");
  img = loadImage("Teahupoo.jpg");
  
  toon = loadShader("texture_frag.glsl");
  //toon = loadShader("two_tweets.glsl");
}

void draw() {
  toon.set("u_resolution", float(width), float(height));
//  toon.set("u_mouse", float(mouseX), float(mouseY));
  toon.set("u_time", millis() / 1000.0);
  
  shader(toon);
  image(img,0,0);
  //saveFrame();
}
