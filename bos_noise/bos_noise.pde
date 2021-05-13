PShader toon;

// https://thebookofshaders.com/07/

void setup() {
  size(720, 720, P3D);
  noStroke();
  fill(204);
  //toon = loadShader("bos_noise.glsl");  // 2d noise compare
  //toon = loadShader("bos_noiseRadial.glsl"); // radial 2d noise
  //toon = loadShader("bos_noiseLines.glsl"); // horizontal lines noise basic
  //toon = loadShader("bos_noiseDistance.glsl"); // quilez 2d noise animation
  //toon = loadShader("bos_noiseSimplex.glsl"); // g basic noise box
}

void draw() {
  toon.set("u_resolution", float(width), float(height));
//  toon.set("u_mouse", float(mouseX), float(mouseY));
  toon.set("u_time", millis() / 1000.0);
  
  shader(toon);
  rect(0,0,width,height);
  //saveFrame();
}
