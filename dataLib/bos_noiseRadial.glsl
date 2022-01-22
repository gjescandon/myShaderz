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

uniform float iRandom1;
uniform float iRandom2;
uniform float iRandom3;

uniform sampler2D texture01;
//uniform sampler2D texture02;
//uniform sampler2D texture03;
//uniform sampler2D texture04;

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


float hash(vec2 p)  // replace this by something better
{
    p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
    return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
}

float noiseValue( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );
	
	vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( hash( i + vec2(0.0,0.0) ), 
                     hash( i + vec2(1.0,0.0) ), u.x),
                mix( hash( i + vec2(0.0,1.0) ), 
                     hash( i + vec2(1.0,1.0) ), u.x), u.y);
}

vec2 hashGradient( vec2 x )  // replace this by something better
{
    const vec2 k = vec2( 0.3183099, 0.3678794 );
    x = x*k + k.yx;
    return -1.0 + 2.0*fract( 16.0 * k*fract( x.x*x.y*(x.x+x.y)) );
}

float noiseGradient( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );
	
	vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( hashGradient( i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ), 
                     dot( hashGradient( i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( hashGradient( i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ), 
                     dot( hashGradient( i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

float integralSmoothstep( float x, float T )
{
    if( x>T ) return x - T/2.0;
    return x*x*x*(1.0-x*0.5/T)/T/T;
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    float color0 = 0.3;
    vec3 color = vec3(color0);

    /// quilez: value noize
    vec2 p = st;

    float myTime = 15. + u_time;
	  vec2 uv = p*vec2(u_resolution.x/u_resolution.y,1.0);
    float aspect = u_resolution.x/u_resolution.y;
	  uv = 2.*uv - vec2(aspect,1.);
    float theta = 0.1*myTime;

    uv.x = integralSmoothstep(abs(0.6*uv.x), 0.3);
    
    // concentric circles
    uv = vec2(length(uv)*cos(theta),length(uv)*sin(theta));
  	float f = 0.0;

    uv = 3.*uv;

    float r = length (uv);
    float a = atan(uv.y * (0.5 + 0.4*cos(0.1*myTime))/abs(uv.x));
    a = atan(uv.y * (0.5 + 0.1*myTime)/abs(uv.x));


		//f = noiseValue( 10.0*vec2(r*a*(1+0.7*cos(u_time*0.4)),a) );
    f = noiseValue( 10.0*vec2(r*a*(myTime*0.04),a) );


	
	  color = vec3(f);

    vec2 p1 = 1.0*(p - vec2(0.5));
    vec3 col1 = texture2D(texture01, vec2(p1.x+0.5, (-1*p1.y+0.5))).xyz;
    
    
    //if (length(col1) < length(color)) color = col1;
    //color = col1;
    // noise line demo
    float xOff = 6.* st.x + myTime;
    float ptc = noize3(xOff);
    //color += vec3(1.- color0 - step(0.01, abs(ptc - st.y)));
    float fz = f * step(0.01, abs(ptc - st.y));
    //color = vec3(fz, fz, f);
    gl_FragColor = vec4(color,1.0);
}