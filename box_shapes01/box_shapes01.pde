PShader toon;

// https://thebookofshaders.com/07/

void setup() {
  size(1280, 720, P3D);
  noStroke();
  fill(204);
  
  //toon = loadShader("bos_07-distance.glsl"); // shape demo
  //toon = loadShader("bos_noise.glsl"); // static noise demo
  //toon = loadShader("bos_noiseLines.glsl"); // noise lines
  //toon = loadShader("bos_patterns.glsl"); // basic pattern boring
  //toon = loadShader("bos_patternsEvenOdd.glsl"); // basic pattern boring
  //toon = loadShader("bos_random.glsl"); // noise squares
  //toon = loadShader("bos_truchet.glsl");
  //toon = loadShader("kachinaFriend1.glsl"); // broke
  //toon = loadShader("mixHSBpolar.glsl"); // color wheel
  //toon = loadShader("spaceStretch01.glsl");
  //toon = loadShader("texture.glsl");  // broke
  
  //toon = loadShader("bos_randomExercise.glsl"); //lines marching
  //toon = loadShader("bos_noiseRadial.glsl"); // radial noise + noise o scope wave
  //toon = loadShader("bos_randomCircles.glsl"); // expanding circles
  // toon = loadShader("rayMarchDummy.glsl"); // simple ray march
  //toon = loadShader("bos_cellular.glsl");
  //toon = loadShader("bos_cellularQuilezPolar.glsl");
  //toon = loadShader("bos_cellularVeronoi.glsl");
  //toon = loadShader("bos_noiseDistance.glsl");
  //toon = loadShader("bos_noiseSimplex.glsl");
  //toon = loadShader("bos_rotation.glsl");
  //toon = loadShader("cell.glsl");
  //toon = loadShader("kachinaFriend2.glsl"); // quilez eyeball
  //toon = loadShader("quilezEquations.glsl");
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
