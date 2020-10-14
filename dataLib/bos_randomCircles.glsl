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

float trishapeOut(vec2 st, int N) {
  st = st *2.-1.;
  // N: Number of sides of your shape

  // Angle and radius from the current pixel
  float a = atan(st.x,st.y)+PI + sin(0.3*u_time);
  float r = TWO_PI/float(N);

  // Shaping function that modulate the distance
  float d = sin(floor(.5+a/r)*r-a)*1.6*length(st);

  return 1.0-smoothstep(.4,.41,d);
}

float trishape(vec2 st, int N) {
  st = st *2.-1.;
  // N: Number of sides of your shape

  // Angle and radius from the current pixel
  float a = atan(st.x,st.y)+PI + sin(0.3*u_time);
  float r = TWO_PI/float(N);

  // Shaping function that modulate the distance
  float d = cos(floor(.5+a/r)*r-a)*length(st);
//  float d = sin(floor(.5+a/r)*r-a)*0.6*length(st);

  return 1.-smoothstep(.4,.41,d);
}

float random (vec2 st) {
    float x2 = 47.5453123 + 10.*sin(0.01*u_time)+ 10.*cos(0.01*u_time);
    return fract(sin(dot(st.xy,
                         vec2(159.9898,78.233)))*
        x2);
}

float random2 (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    float N = 3.;
    vec2 p = 2.*st - 1.;
    p *= N;

    float r = p.x*p.x+p.y*p.y;
    float rr = random2(p);
    //r = 0.7*abs(sin(0.2*u_time)*sin(0.2*u_time))*rr*sin(r  - 0.6*u_time );
    r = pow(sin(r  - 0.09*u_time + 0.6* rr),2.);
    vec3 color = vec3(0.,fract((1.4 + 0.9*pow(cos(0.2*u_time),1.3))*(r)),0.5);
    gl_FragColor = vec4(color,1.0);
}