PShader toon;
float rr1, rr2, rr3;
// https://www.iquilezles.org/www/articles/deform/deform.htm
PImage img1;
float[] rarr;

void setup() {
  size(720, 720, P3D);
  noStroke();
  fill(204);
  img1 = loadImage("catApril01.png");
  
  
  // Inigo Quilez
    toon = loadShader("metaballs.glsl");  // messy something
    //toon = loadShader("iqAnalyticNormals.glsl");  // messy something

  //toon = loadShader("0gColorStripes.glsl"); // moving stripes :: many
  //toon = loadShader("0gBrokenColorStripes.glsl"); // moving stripes :: many
  //toon = loadShader("0gBlues.glsl"); // moving 2D :: many
  
  //toon = loadShader("0gColorCircles.glsl"); // moving circles
  
  //toon = loadShader("0gUniformArrays.glsl"); // static color gradient
  //toon = loadShader("0gColorTest.glsl");  // static color test
  //toon = loadShader("checkerBoard.glsl");  // messy something
  //toon = loadShader("rayMarchDummy.glsl");  // messy something
  //toon = loadShader("bullsEye.glsl"); // bullseye mask
  //toon = loadShader("0gTemplate.glsl");  // techno mask
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
  toon.set("iResolution", float(width), float(height)); //*** FROM SHADER TOY uniform vec3 iResolution;
  float tmilli = millis() / 1000.0;
  toon.set("iTime", tmilli); //uniform float iTime;
  toon.set("iRandom1", rr1);
  toon.set("iRandom2", rr2);
  toon.set("iRandom3", rr3);
  toon.set("iColorLimiter",1.0);
  toon.set("iFrame", frameCount);
  toon.set("iMouse", mouseX, mouseY);  // uniform vec4 iMouse;
  toon.set("texture01", img1);
  
    
//*** FROM SHADER TOY
//uniform float iTimeDelta;
//uniform float iFrame;
//uniform float iChannelTime[4];
//uniform vec4 iDate;
//uniform float iSampleRate;
//uniform vec3 iChannelResolution[4];
// uniform samplerXX iChanneli;


  toon.set("iRarr", rarr);
  
  println(frameCount );
  
  fill(0.);
  rect(0,0,width,height);
  shader(toon);

  
  saveFrame();
}
