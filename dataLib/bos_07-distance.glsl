// Author: Inigo Quiles
// Title: Expo
#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER
#define PI 3.14159265359
#define TWO_PI 6.28318530718 

uniform vec2 u_resolution;
uniform vec3 u_mouse;
uniform float u_time;

float shape(vec2 st){
    vec2 pos = vec2(0.5)-st;

    float r = length(pos)*2.0;
    float a = atan(pos.y,pos.x);

    float f = cos(a*3.);
    f = abs(cos(a*3.));
    f = abs(cos(a*2.5))*.5+.3;
     f = abs(cos(a*9.)*sin(a*4.))*.8+.1;
    // f = smoothstep(-.5,1., cos(a*10.))*0.2+0.5;

    //color = vec3( 1.-smoothstep(f,f+0.02,r) );
    return ( 1.-smoothstep(f,f+0.02,r) );
}

float trishape(vec2 st, int N) {
  st = st *2.-1.;
  // N: Number of sides of your shape

  // Angle and radius from the current pixel
  float a = atan(st.x,st.y)+PI + sin(u_time);
  float r = TWO_PI/float(N);

  // Shaping function that modulate the distance
  float d = cos(floor(.5+a/r)*r-a)*length(st);

  return 1.0-smoothstep(.4,.41,d);
}

void main(){
  vec2 st = 2.*gl_FragCoord.xy/u_resolution.xy - vec2(0.75,0.5);
  st.x *= u_resolution.x/u_resolution.y;
  vec3 color = vec3(0.0);
  float d = 0.0;

  // Remap the space to -1. to 1.
  vec2 p = st *2.-1.;

  // Make the distance field
  d = length( abs(p)-.2 );
   d = length( min(abs(p)-.3,0.) );
   d = length( max(abs(p)-.6,0.) );

  // Visualize the distance field
  gl_FragColor = vec4(vec3(fract(d*10.0)),1.0);

  // Drawing with the distance field
  color = vec3( step(.3,d));

  vec3 colorB = vec3(0.2,0.2,0.8);
  float pct = shape(st);
  color = (1-pct) * color + pct * colorB;

  pct = trishape(st, 5);
  vec3 colorC = vec3(0.2,0.8,0.2);
  color = (1-pct) * color + pct * colorC;

   gl_FragColor = vec4(color, 1.);
  // gl_FragColor = vec4(vec3( step(.3,d) * step(d,.4)),1.0);
  // gl_FragColor = vec4(vec3( smoothstep(.3,.4,d)* smoothstep(.6,.5,d)) ,1.0);
}