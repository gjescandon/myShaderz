PShader toon;
float rr1, rr2, rr3;
// https://www.iquilezles.org/www/articles/deform/deform.htm
PImage img;
float[] rarr;

void setup() {
  size(1280, 720, P3D);
  noStroke();
  fill(204);
  //img = loadImage("seaShellFoam_mirror720.jpg");
  //toon = loadShader("0gColorStripes.glsl");
  //toon = loadShader("0gQuilezJenDo.glsl");
  toon = loadShader("0gUniformArrays.glsl");
  
  //toon = loadShader("bullsEye.glsl");
  //toon = loadShader("0gTemplate.glsl");
  rr1 = random(1);
  rr2 = random(1);
  rr3 = random(1);
  rarr = new float[4];
  for (int i = 0; i < 4; i++) {
    rarr[i] = random(1);
  }
}

void draw() {
  toon.set("iResolution", float(width), float(height));
  float tmilli = millis() / 1000.0;
  toon.set("iTime", tmilli);
  toon.set("iRandom1", rr1);
  toon.set("iRandom2", rr2);
  toon.set("iRandom3", rr3);
  toon.set("iRarr", rarr);
  
  //println(frameCount );
  
  
  shader(toon);
  rect(0,0,width,height);
  //image(img,0,0);
  //saveFrame();
}
