PShader toon;
float rr1, rr2, rr3;
PImage img, img1, img2, img3, img4;
float[] rarr;

void setup() {
  size(720, 720, P3D);
  noStroke();
  fill(204);
  toon = loadShader("stripesAndTextures.glsl"); // moving stripes
  //toon = loadShader("0gGrids.glsl"); // wall of moving squares
  rr1 = random(1);
  rr2 = random(1);
  rr3 = random(1);
   img2 = loadImage("catApril01.png");
   img1 = loadImage("eyeGreen.png");
   img4 = loadImage("xpCat.png");
   img3 = loadImage("eyePurple.png");

  
}

void draw() {
  toon.set("iResolution", float(width), float(height));
  float tmilli = millis() / 1000.0;
  toon.set("iTime", tmilli);
  toon.set("iRandom1", rr1);
  toon.set("iRandom2", rr2);
  toon.set("iRandom3", rr3);
  toon.set("iColorLimiter",1.0);
  toon.set("iFrame", frameCount);
    toon.set("texture01", img1);
    toon.set("texture02", img2);
    toon.set("texture03", img3);
    toon.set("texture04", img4);
  
  
  /*  *** FROM SHADER TOY
  uniform vec3 iResolution;
uniform float iTime;
uniform float iTimeDelta;
uniform float iFrame;
uniform float iChannelTime[4];
uniform vec4 iMouse;
uniform vec4 iDate;
uniform float iSampleRate;
uniform vec3 iChannelResolution[4];
uniform samplerXX iChanneli;*/

  
  println(frameCount );
  
  
  shader(toon);

  rect(0,0,width,height);
  //saveFrame();
}
