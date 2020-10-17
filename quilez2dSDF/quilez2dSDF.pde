PShader toon;

// https://www.iquilezles.org/www/articles/deform/deform.htm
PImage img;
void setup() {
  size(720, 720, P3D);
  noStroke();
  fill(204);
  img = loadImage("seaShellFoam_mirror720.jpg");
  toon = loadShader("texture_frag.glsl");
}

void draw() {
  toon.set("iResolution", float(width), float(height));
//  toon.set("u_mouse", float(mouseX), float(mouseY));
  toon.set("iTime", millis() / 1000.0);
  
  shader(toon);
  image(img,0,0);
  //saveFrame();
}
