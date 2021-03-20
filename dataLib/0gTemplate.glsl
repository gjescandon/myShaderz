#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define PI_HALF 1.5707963268
#define PI_QRTR 0.78539816339

#define TWO_PI 6.28318530718 

uniform vec2 iResolution;
//uniform vec2 u_mouse;
uniform float iTime;
uniform float iRandom1;
uniform float iRandom2;
uniform float iRandom3;

//uniform sampler2D texture;

float random (vec2 st) {
    float x2 = 47.5453123 + 10.*sin(0.01*iTime)+ 10.*cos(0.01*iTime);
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


//https://www.iquilezles.org/www/articles/palettes/palettes.htm  

  
 
 
 float getColor1D(float t0) {
   // **** RGB in here **** 
  float a1 = 0.2; // 

  float b1 = 0.2; //oscilators amplitude

  float c1 = 1.5 * (1 + 0.5* sin(0.01*iTime)); //input amplitude

  float d1 = 0.; // offset

  float factor = 1.0;

  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  b1 = iRandom1;
  //c1 = iRandom2;
  d1 = iRandom3;

  float h1 = factor * (a1 + b1 * cos(TWO_PI*(c1*tnom+d1)));
  return h1; //fract(h1);   
 }

  vec3 getColor(float t0) {
   // **** RGB in here **** 
  float a1 = 0.6; // red
  float a2 = 0.5;  // green
  float a3 = 0.7;  // blue
  
  float b1 = 0.4; //oscilators amplitude
  float b2 = 0.5;
  float b3 = 0.1;

  float c1 = 1.0; //input amplitude
  float c2 = 1.0;
  float c3 = 1.0;

  float d1 = 0.; // offset
  float d2 = 0.3;
  float d3 = 0.6;
  float factor = 1.0;

  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  d1 = iRandom1;
  d2 = iRandom2;
  d3 = iRandom3;
  
  float b1f = b1 * cos(TWO_PI*(c1*tnom+d1));
  float red1 = fract(factor * (a1 + b1f));
  float b2f = b2 * cos(TWO_PI*(c2*tnom+d2));
  float grn2 = fract(factor * (a2 + b2f));
  float b3f = + b3 * cos(TWO_PI*(c3*tnom+d3));
  float blu3 = fract(factor * (a3 + b3f));
  vec3 c = vec3(red1,grn2,blu3);
  return c;   
 }

float sdEllipse( in vec2 p, in vec2 ab )
{
    p = abs(p); if( p.x > p.y ) {p=p.yx;ab=ab.yx;}
    float l = ab.y*ab.y - ab.x*ab.x;
    float m = ab.x*p.x/l;      float m2 = m*m; 
    float n = ab.y*p.y/l;      float n2 = n*n; 
    float c = (m2+n2-1.0)/3.0; float c3 = c*c*c;
    float q = c3 + m2*n2*2.0;
    float d = c3 + m2*n2;
    float g = m + m*n2;
    float co;
    if( d<0.0 )
    {
        float h = acos(q/c3)/3.0;
        float s = cos(h);
        float t = sin(h)*sqrt(3.0);
        float rx = sqrt( -c*(s + t + 2.0) + m2 );
        float ry = sqrt( -c*(s - t + 2.0) + m2 );
        co = (ry+sign(l)*rx+abs(g)/(rx*ry)- m)/2.0;
    }
    else
    {
        float h = 2.0*m*n*sqrt( d );
        float s = sign(q+h)*pow(abs(q+h), 1.0/3.0);
        float u = sign(q-h)*pow(abs(q-h), 1.0/3.0);
        float rx = -s - u - c*4.0 + 2.0*m2;
        float ry = (s - u)*sqrt(3.0);
        float rm = sqrt( rx*rx + ry*ry );
        co = (ry/sqrt(rm-rx)+2.0*g/rm-m)/2.0;
    }
    vec2 r = ab * vec2(co, sqrt(1.0-co*co));
    return length(r-p) * sign(p.y-r.y);
}


void main( void )
{
    
    vec2 p = (2.0*gl_FragCoord.xy-iResolution.xy)/iResolution.y;
    float h = 1.0;
    float w = 3.0*h;
    float ho = 0.1;
    float wo = 0.2 * w;
    vec2 ra = vec2(w,h) + vec2(wo, ho)*cos(0.2*iTime + vec2(0.0,PI_QRTR) + 0.0);
    //float d = sdRhombus(p, ra);
    float d = sdEllipse((p+vec2(0,0.8)), ra);
    float noff = noiseValue(10.*(2+sin(0.1*iTime+PI_HALF))*p);
    vec3 col = vec3(1.0) - sign(d-0.3*noff)*vec3(1.0,1.0,1.0);
    //col -= vec3(d); // solo this for burning retina thing
    //col *= 1.0 - exp(-2.0*abs(d));
    //col *= 0.8 + 0.4*cos(60.0*d);
    //col = mix(col, vec3(1.0), 1.0-smoothstep(0.0, 0.02, abs(d - 0.1)));
    gl_FragColor = vec4(col.x * getColor1D(0.2*iTime),col.y * getColor1D(0.4*iTime),col.z * getColor1D(0.1*iTime), 1.0);
}
