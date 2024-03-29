QuilezFunctions qf;
GeoFunctions gf;
JdUnit jd;
PShader toon;
float rr1, rr2, rr3;
// https://www.iquilezles.org/www/articles/deform/deform.htm
PImage img;
float[] rarr;
float colorLimiter;

NoizeBob cb,zbob, xbob, ybob, swb;
int cnt;
void setup() {
  size(1280, 720, P3D);
  toon = loadShader("0gQuilezJenDo.glsl");
  //toon = loadShader("0gQuilezJenDoTwo.glsl");
  
  rr1 = random(1);
  rr2 = random(1);
  rr3 = random(1);
  colorLimiter = 0.7;
  
  rarr = new float[4];
  for (int i = 0; i < 4; i++) {
    rarr[i] = random(1);
  }


  qf = new QuilezFunctions();
  gf = new GeoFunctions();
  jd = new JdUnit();
  cb = new NoizeBob(1.0, 0.002, 0.5);
  swb = new NoizeBob(1.0, 0.001, 0.9);
  zbob = new NoizeBob(1.0, 0.01, 0.3);
  xbob = new NoizeBob(1., 0.001, 0.3);
  ybob = new NoizeBob(1., 0.001, 0.3);
  background(0.);

 }

void draw() {
  background(0.);
    if (frameCount%600==0) rr3 = random(1);

  toon.set("iResolution", float(width), float(height));
  float tmilli = millis() / 1000.0;
  toon.set("iTime", tmilli);
  toon.set("iRandom1", rr1);
  toon.set("iRandom2", rr2);
  toon.set("iRandom3", rr3);
  toon.set("iRandom3", rr3);
  toon.set("iColorLimiter", colorLimiter);
  toon.set("iRarr", jd.getFloatArr());
  
  //println(jd.getFloatArr()); // this looks correct.
  
  //rect(0,0,width,height);
  shader(toon);
  fill(0);
  rect(0,0,width,height);
  //jd.draw();
  
  println(frameCount);
  //saveFrame();
} 
