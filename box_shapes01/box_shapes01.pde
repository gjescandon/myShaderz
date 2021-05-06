PShader toon;

// https://thebookofshaders.com/07/

void setup() {
  size(1280, 720, P3D);
  noStroke();
  fill(204);
  toon = loadShader("bos_07-01.glsl");
  //toon = loadShader("bos_07-distance.glsl"); // shape demo
  //toon = loadShader("bos_noise.glsl"); // static noise demo
  //toon = loadShader("bos_noiseLines.glsl"); // noise lines
  //toon = loadShader("bos_noiseRadial.glsl"); // radial noise + noise o scope wave
  //toon = loadShader("bos_patterns.glsl");
  //toon = loadShader("bos_patternsEvenOdd.glsl");
  //toon = loadShader("bos_random.glsl");
  //toon = loadShader("bos_randomExercise.glsl");
  //toon = loadShader("bos_randomCircles.glsl");
  //toon = loadShader("bos_truchet.glsl");
  //toon = loadShader("kachinaFriend1.glsl");
  //toon = loadShader("rayMarchDummy.glsl");
  //toon = loadShader("bos_cellular.glsl");
  // borken :: toon = loadShader("bos_cellularQuilezPolar.glsl");
  //toon = loadShader("bos_cellularVeronoi.glsl");
  //toon = loadShader("bos_noiseDistance.glsl");
  //toon = loadShader("bos_noiseSimplex.glsl");
  //toon = loadShader("bos_rotation.glsl");
  //toon = loadShader("cell.glsl");
  //toon = loadShader("kachinaFriend2.glsl");
  //toon = loadShader("mixHSBpolar.glsl");
  //toon = loadShader("quilezEquations.glsl");
  //toon = loadShader("spaceStretch01.glsl");
  //toon = loadShader("texture.glsl");
  //toon.set("fraction", 1.0);
}

void draw() {
  toon.set("u_resolution", float(width), float(height));
  toon.set("u_mouse", float(mouseX), float(mouseY));
  toon.set("u_time", millis() / 1000.0);
  
  shader(toon);
  rect(0,0,width,height);
  //saveFrame();
}
