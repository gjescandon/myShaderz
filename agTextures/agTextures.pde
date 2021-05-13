PImage img1, img2;
PShader colorShader;

void setup() {
  size(1280, 720, P3D);
   img1 = loadImage("lachoy.jpg");
    img2 = loadImage("gselfieOil.JPG");
    colorShader = loadShader("0gTextures.glsl");
}

void draw() {
  background(0);
  colorShader.set("iResolution", float(width), float(height));
  colorShader.set("iTime", millis() / 1000.0);
    colorShader.set("texture01", img1);
    colorShader.set("tex01W", img1.width);
    colorShader.set("tex01H", img1.height);
    colorShader.set("texture02", img2);
    colorShader.set("tex02W", img2.width);
    colorShader.set("tex02H", img2.height);
  
  shader(colorShader);
  rect(0,0, width,height);
}
