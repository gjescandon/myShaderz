PShader toon;

// https://thebookofshaders.com/07/
  float iRandom1 = random(1);
  float iRandom2 = random(1);
  float iRandom3 = random(1);

void setup() {
  size(720  , 720, P3D);
  noStroke();
  fill(204);
  
  toon = loadShader("patterns01.glsl");
  //toon = loadShader("gFallingShapes.glsl");
  //toon.set("fraction", 1.0);
  println(iRandom1);
  println(iRandom2);
  println(iRandom3);
  
}

void draw() {
  toon.set("u_resolution", float(width), float(height));
  toon.set("u_mouse", float(mouseX), float(mouseY));
  toon.set("u_time", millis() / 1000.0);
  toon.set("iRandom1", iRandom1);
  toon.set("iRandom2", iRandom2);
  toon.set("iRandom3", iRandom3);
  toon.set("iColorLimiter", 0.4);
  shader(toon);
  rect(0,0,width,height);
  //saveFrame();
  println(frameCount);
}
