PShader toon;

// https://thebookofshaders.com/07/

void setup() {
  size(1280, 720, P3D);
  noStroke();
  fill(204);
  
  toon = loadShader("0patterns.glsl");
  //toon.set("fraction", 1.0);
}

void draw() {
  toon.set("u_resolution", float(width), float(height));
  toon.set("u_mouse", float(mouseX), float(mouseY));
  toon.set("u_time", millis() / 1000.0);
  
  shader(toon);
  rect(0,0,width,height);
  //saveFrame();
  //println(frameCount);
}
