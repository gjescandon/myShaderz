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

    vec2 pgrid = st* 10.0; // Scale the coordinate system by 10
    vec2 ipos = floor(pgrid);  // get the integer coords
    vec2 fpos = fract(pgrid);  // get the fractional coords

    // Assign a random value based on the integer coord
    vec3 color = vec3(random( ipos ));

    float rnd = random( st );
    float tri = trishape(st, 5);
    gl_FragColor = vec4(color * vec3(rnd * tri),1.0);
}