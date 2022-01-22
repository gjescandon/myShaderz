PShader toon;
float rr1, rr2, rr3;
PImage img, img1, img2, img3, img4;
float[] rarr;

// https://thebookofshaders.com/07/

void setup() {
  size(720, 720, P3D);
  noStroke();
  fill(204);
  //toon = loadShader("bos_noise.glsl");  // 2d noise compare
  toon = loadShader("bos_noiseRadial.glsl"); // radial 2d noise
  //toon = loadShader("bos_noiseLines.glsl"); // horizontal lines noise basic
  //toon = loadShader("bos_noiseDistance.glsl"); // quilez 2d noise animation
  //toon = loadShader("bos_noiseSimplex.glsl"); // g basic noise box
  
  rr1 = random(1);
  rr2 = random(1);
  rr3 = random(1);
   img1 = loadImage("martin00028_L.png");
   //img2 = loadImage("catApril01.png");
   //img3 = loadImage("eyePurple.png");  
   //img4 = loadImage("xpCat.png");
}

void draw() {
  toon.set("u_resolution", float(width), float(height));
//  toon.set("u_mouse", float(mouseX), float(mouseY));
  toon.set("u_time", millis() / 1000.0);
  toon.set("iRandom1", rr1);
  toon.set("iRandom2", rr2);
  toon.set("iRandom3", rr3);
  toon.set("iColorLimiter",1.0);
  toon.set("iFrame", frameCount);
  toon.set("texture01", img1);  
  shader(toon);
  rect(0,0,width,height);
  //saveFrame();
}
