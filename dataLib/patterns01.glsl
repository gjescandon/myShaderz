// Author: Inigo Quiles
// Title: Expo
#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER
#define PI 3.14159265359
#define TWO_PI 6.28318530718 
#define BPM 94

uniform vec2 u_resolution;
uniform float u_time;
uniform float iRandom1;
uniform float iRandom2;
uniform float iRandom3;
uniform float[100] iRarr;
uniform float iColorLimiter;


float bpmms(float time_) {
  return BPM * floor(time_ * 0.5 * 60/BPM);
}

  vec3 getColor(float t0) {
   // **** RGB in here **** 
  float a1 = 0.6; // red
  float a2 = 0.5;  // green
  float a3 = 0.7;  // blue
  
  float b1 = 0.4; //oscilators amplitude
  float b2 = 0.2;
  float b3 = 0.5;

  float c1 = 1 + floor(10*iRandom1); // sin rate
  float c2 = 1 + floor(10*iRandom1);
  float c3 = 1 + floor(10*iRandom1);
  

  float d1 = 0.; // offset
  float d2 = 0.3;
  float d3 = 0.6;
  float factor = 1.0;

  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  a1 = fract(10*iRandom1);
  a2 = fract(10*iRandom2);
  a3 = fract(10*iRandom3);

  b1 = fract(100*iRandom1);
  b2 = fract(100*iRandom2);
  b3 = fract(100*iRandom3);

  d1 = fract(1000*iRandom1);
  d2 = fract(1000*iRandom2);
  d3 = fract(1000*iRandom3);

  float iColorLimiter = 0.9;
  float b1f = b1 * cos(TWO_PI*(c1*tnom+d1));
  float red1 = clamp(factor * (a1 + b1f),0.,iColorLimiter);
  float b2f = b2 * cos(TWO_PI*(c2*tnom+d2));
  float grn2 = clamp(factor * (a2 + b2f),0.,iColorLimiter);
  float b3f = + b3 * cos(TWO_PI*(c3*tnom+d3));
  float blu3 = clamp(factor * (a3 + b3f),0.,iColorLimiter);
  vec3 c = vec3(red1,grn2,blu3);
  return c;   
 }

  vec3 getColorDark(float t0) {
   // **** RGB in here **** 
  float a1 = 0.6; // red
  float a2 = 0.5;  // green
  float a3 = 0.7;  // blue
  
  float b1 = 0.4; //oscilators amplitude
  float b2 = 0.2;
  float b3 = 0.5;

  float c1 = 1 + floor(10*iRandom1); // sin rate
  float c2 = 1 + floor(10*iRandom1);
  float c3 = 1 + floor(10*iRandom1);
  

  float d1 = 0.; // offset
  float d2 = 0.3;
  float d3 = 0.6;
  float factor = 1.0;

  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  a1 = fract(10*iRandom1);
  a2 = fract(10*iRandom2);
  a3 = fract(10*iRandom3);

  b1 = fract(100*iRandom1);
  b2 = fract(100*iRandom2);
  b3 = fract(100*iRandom3);

  d1 = fract(1000*iRandom1);
  d2 = fract(1000*iRandom2);
  d3 = fract(1000*iRandom3);

  
  float b1f = b1 * cos(TWO_PI*(c1*tnom+d1));
  float red1 = clamp(factor * (a1 + b1f),0.,iColorLimiter);
  float b2f = b2 * cos(TWO_PI*(c2*tnom+d2));
  float grn2 = clamp(factor * (a2 + b2f),0.,iColorLimiter);
  float b3f = + b3 * cos(TWO_PI*(c3*tnom+d3));
  float blu3 = clamp(factor * (a3 + b3f),0.,iColorLimiter);
  vec3 c = vec3(red1,grn2,blu3);
  return c;   
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

vec2 tile(vec2 st, float N) {
   float aspect = u_resolution.x/u_resolution.y;
    st *= N;      // Scale up the space by N
    // Now we have N spaces that goes from 0-1
  vec2 ret = fract(st); // Wrap around 1.0
  ret.x = ret.x*aspect;
  ret = 2.*ret - vec2(aspect, 1.);
  return ret;
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

float sdCircleNoized( vec2 p, float r )
{
    float sx = iRandom1/10.;
    float sy = iRandom2/10.;
    p = vec2(p.x + 0.4*noize3(p.x + sin(sx*bpmms(u_time))), p.y + 0.4*noize3(p.y + sin(sy*bpmms(u_time) + 0.8)));
    return length(p) - r;
}


float sdStar5(in vec2 p, in float r, in float rf)
{
    const vec2 k1 = vec2(0.809016994375, -0.587785252292);
    const vec2 k2 = vec2(-k1.x,k1.y);
    p.x = abs(p.x);
    p -= 2.0*max(dot(k1,p),0.0)*k1;
    p -= 2.0*max(dot(k2,p),0.0)*k2;
    p.x = abs(p.x);
    p.y -= r;
    vec2 ba = rf*vec2(-k1.y,k1.x) - vec2(0,1);
    float h = clamp( dot(p,ba)/dot(ba,ba), 0.0, r );
    return length(p-ba*h) * sign(p.y*ba.x-p.x*ba.y);
}

float sdStar5Noized(in vec2 p, in float r, in float rf) {
    float sx = iRandom1/10.;
    float sy = iRandom2/10.;
    p = vec2(p.x + 0.4*noize3(p.x + sin(sx*bpmms(u_time))), p.y + 0.4*noize3(p.y + sin(sy*bpmms(u_time) + 0.8)));
    return sdStar5(p, r , rf);
}

vec2 renderDeformation( vec2 st ) {
    float x = 0.;
    float y = 0.;
    x =  -1.00f + 2.00*st.x;
    y = -1.00f + 2.00*st.y;
    float d = sqrt( x*x + y*y );
    float a = atan( y, x );

    // magic formulas here
    float offset = 0.06*u_time;
    float r = d + sin(offset);
    float u = cos( a )/r;  // A: horizon infinity
    float v = sin( a )/r;

    
    u = x*cos(2*r) - y*sin(2*r); // B: swirl circle
    v = y*cos(2*r) + x*sin(2*r);

    //u = 0.3/(r+0.5*x); // C: radial segments
    //v = 3*a/PI;

    //u = 1/(r+0.5+0.5*sin(5*a)); // D: more radials
    //v = a*3/PI;    


    //u = 0.1*x/(0.11+r*0.5); // E: horizon split
    //v = 0.1*y/(0.11+r*0.5);

    //u = 0.02*y+0.03*cos(a*3)/r; // F: yin yang pattern :: very intersting P/2 - PI
    //v = 0.02*x+0.03*sin(a*3)/r;

    //u = 0.5*a/PI; // G: cirular bullseye pattern
    //v = sin(3*r);

    //u = r*cos(a+r); // H: rectangle s-curves
    //v = r*sin(a+r);

    //u = x/abs(y);  // I: horizontal stripes :: inifinity
    //v  = 1/abs(y);

    return vec2(fract( u ),fract( v ));

}

void main() {
  float aspect = u_resolution.x/u_resolution.y;
	vec2 st = gl_FragCoord.xy/u_resolution;
  //st.y += sin(0.01*u_time);
  vec2 st13 = st;
  st13.y += sin(0.017*u_time);
  st13 = tile(renderDeformation(st13),13);
  
  vec2 st5 = st;
  st5.x += sin(0.047*u_time);
  st5.y += cos(0.047*u_time);
  st5 = tile(st5, 5);
  
  vec2 st3 = st - 0.6;
  st3.x -= 0.05*sin(0.9*u_time);
  st3.y -= 0.05*cos(0.9*u_time);
  //st3 = tile(st3, 3);
  
  vec3 color = vec3(0.0);


    float cc13 = 1.0-smoothstep(0.0,0.2*noize3(0.01*bpmms(u_time)),sdCircleNoized(st13,0.7));
    float cc5 = 1.0-smoothstep(0.0,0.01,sdCircleNoized(st5,0.5));
    float cc5b = 1.0-smoothstep(0.0,0.01,sdCircleNoized(st5,0.3));
    float cc3 = 1.0-smoothstep(0.0,0.01,sdStar5Noized(st3,0.4, 0.4));
    float cc3b = 1.0-smoothstep(0.0,0.01,sdStar5Noized(st3,0.3, 0.3));
    color = cc13 * getColorDark(sin(0.03*bpmms(u_time)));
    
    color *= (1-cc5);
    color += cc5 * getColor(sin(0.004*u_time));
    color += cc5b * getColor(sin(0.004*u_time + 0.8));
    
    color *= (1-cc3);
    color += cc3 * getColor(sin(0.007*u_time));
    color += cc3b * getColor(sin(0.007*bpmms(u_time)));


	gl_FragColor = vec4(color,1.0);
}