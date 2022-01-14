PImage img1, img2, img3, img4;
PShader colorShader;

void setup() {
  size(720, 720, P3D);
   img1 = loadImage("eggplant36.png");
   img2 = loadImage("gselfieOil.JPG");
   img3 = loadImage("gselfieOil.JPG");
   img4 = loadImage("gselfieOil.JPG");
    colorShader = loadShader("0gTextures.glsl");
    //colorShader = loadShader("iqFractalBitMapTrap.glsl");
}

void draw() {
  background(0);
  colorShader.set("iResolution", float(width), float(height));
  colorShader.set("iTime", millis() / 1000.0);
    colorShader.set("texture01", img1);
    //colorShader.set("tex01W", img1.width);
    //colorShader.set("tex01H", img1.height);
    colorShader.set("texture02", img2);
    colorShader.set("texture03", img4);
    colorShader.set("texture04", img3);
    //colorShader.set("tex02W", img2.width);
    //colorShader.set("tex02H", img2.height);
  
  shader(colorShader);
  rect(0,0, width,height);
  println(frameCount);
  //saveFrame();
}
