PShader toon;

// https://thebookofshaders.com/07/

void setup() {
  size(720, 720, P3D);
  noStroke();
  fill(204);
  //toon = loadShader("bos_cellular.glsl");
  //toon = loadShader("bos_cellularVeronoi.glsl");
  //toon = loadShader("stippling.glsl");
  toon = loadShader("cell.glsl");
  //toon = loadShader("cracks.frag");
  //toon = loadShader("bos_cellularQuilezPolar.glsl");
//  toon = loadShader("bos_cellularQuilezVeronoi.glsl");
}

void draw() {
  toon.set("u_resolution", float(width), float(height));
  toon.set("u_mouse", float(mouseX), float(mouseY));
  toon.set("u_time", millis() / 1000.0);
  
  shader(toon);
  rect(0,0,width,height);
  //saveFrame();
}
