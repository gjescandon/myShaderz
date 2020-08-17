PShader toon;

// https://thebookofshaders.com/07/

void setup() {
  size(720, 720, P3D);
  noStroke();
  fill(204);
  toon = loadShader("quilezEyeball.glsl");
}

void draw() {
  toon.set("u_resolution", float(width), float(height));
//  toon.set("u_mouse", float(mouseX), float(mouseY));
  toon.set("u_time", millis() / 1000.0);
  
  shader(toon);
  rect(0,0,width,height);
  //saveFrame();
}
