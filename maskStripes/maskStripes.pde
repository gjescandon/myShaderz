PShader toon;
float rr1, rr2, rr3;
// https://www.iquilezles.org/www/articles/deform/deform.htm
PImage img;
float[] rarr;

void setup() {
  size(1280, 720, P3D);
  noStroke();
  fill(204);
  //toon = loadShader("maskStripes.glsl"); // moving stripes :: many
  
  //toon = loadShader("bullsEye.glsl"); // bullseye mask
  //toon = loadShader("sdfMasks.glsl");  // techno mask
  toon = loadShader("kateDehler_Mask.glsl");  // dehler mask
  rr1 = random(1);
  rr2 = random(1);
  rr3 = random(1);
  rarr = new float[4];
  for (int i = 0; i < 4; i++) {
    rarr[i] = random(1);
  }
  println(rr1);
  println(rr2);
  println(rr3);
  
  colorMode(HSB, 1.0);
  
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


  toon.set("iRarr", rarr);
  
  println(frameCount );
  
  fill(0.);
  rect(0,0,width,height);
    shader(toon);

  
  //saveFrame();
  println(frameCount);
}
