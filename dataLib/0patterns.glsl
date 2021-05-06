// Author: Inigo Quiles
// Title: Expo
#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER
#define PI 3.14159265359
#define TWO_PI 6.28318530718 

uniform vec2 u_resolution;
uniform float u_time;

float rand(float x) {
    return fract(sin(x) * 100.);
}

float noize1(float x) {
  float i = floor(x);  // integer
  float f = fract(x);  // fraction
  float y = rand(i); //rand() is described in the previous chapter
  float randMix = 1.;
  y = mix(rand(i), rand(i + randMix), f);

  return y;
}

float noize2(float x) {
  float i = floor(x);  // integer
  float f = fract(x);  // fraction
  float y = rand(i); //rand() is described in the previous chapter

  y = mix(rand(i), rand(i + 1.0), smoothstep(0.,1.,f));
  return fract(y);
}
float noize3(float x) {
  float i = floor(x);  // integer
  float f = fract(x);  // fraction
  float u = f * f * (3.0 - 2.0 * f );
  float y = rand(i); //rand() is described in the previous chapter
  float randMix = 1.;
  y = mix(rand(i), rand(i + randMix), smoothstep(0.,1.,u));
  return fract(y);
}

vec2 tile(vec2 st, float N) {
    st *= N;      // Scale up the space by N
    // Now we have N spaces that goes from 0-1
    return fract(st); // Wrap around 1.0

}

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}




float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}




void main() {
	vec2 st = 2.*gl_FragCoord.xy/u_resolution - vec2(0.5);
    vec3 color = vec3(0.0);

    //color = vec3(st,0.0);

   // Divide the space in 4
    //vec2 pbox = tile(st,1 + 10 * noize3(0.01*u_time));

    // Use a matrix to rotate the space 45 degrees
    //pbox = rotate2D(pbox,PI*0.25);

    // Draw a square
    //float r = length (pbox);
    //float a = atan(pbox.y * (0.5 + 0.4*cos(0.1*u_time))/abs(pbox.x));

    //color = vec3(box(st,vec2(0.7),0.01));


    //color = vec3(sdCircle(st,0.3));
    //color = vec3(p.x);
    //float pct = trishape(tile(st,7), 3);
    //vec3 colorB = vec3(0.0,0.8,0.2);
    //color = (1-pct)*color + pct * colorB;


	gl_FragColor = vec4(color,1.0);
}