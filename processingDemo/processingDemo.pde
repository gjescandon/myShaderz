PShape can;
float angle;
PShader colorShader;

void setup() {
  size(640, 360, P3D);
  PImage label = loadImage("lachoy.jpg");
  can = createCan(100, 200, 32, label);
  colorShader = loadShader("colorFrag.glsl", "colorVert.glsl");
}

void draw() {
  background(0);
  shader(colorShader);
  translate(width/2, height/2);
  rotateY(angle);
  shape(can);
  angle += 0.01;
  fill(200);
  rect(20,20, width,200);
}

PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);
  }
  sh.endShape();
  return sh;
}
