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

float randomB (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(100*iRandom1,100*iRandom2)))*
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

float noiseVal( in vec2 p )
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

  float c1 = 1.5 * (1 - 0.8* cos(0.03*iTime)); //input amplitude

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
  float b2 = 0.2;
  float b3 = 0.5;

  float c1 = 1.0; //input amplitude
  float c2 = 1.0;
  float c3 = 1.0;

  float d1 = 0.; // offset
  float d2 = 0.3;
  float d3 = 0.6;
  float factor = 1.0;

  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  a1 = iRandom1;
  a2 = 0.1 * iRandom2;
  a3 = iRandom3;

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

float sdCircleNoize( vec2 p, float r )
{
  vec2 pn = vec2(p.x+ 0.1*sin(noize3(0.5*iTime)),p.y+ 0.1*sin(noize3(0.2*iTime)));
    return length(pn) - r;
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
    
    vec2 p = vec2(1.);
    //p = ((2.0+sin(0.03*iTime))*gl_FragCoord.xy-iResolution.xy)/iResolution.y;
    p = gl_FragCoord.xy/iResolution.xy - vec2(0.5);
    p.x = p.x + 0.5*sin(noize3(0.1*iTime) + 0.06*iTime + 10.*iRandom1);
    p.y = p.y + 0.2*sin(noize3(0.2*iTime) + 0.05*iTime  + 10.*iRandom2);

    float bobSin = sin(0.04*iTime);
    float bobTim = 0.007*iTime;


    float bob = 0.03*random(p);
    float xoff = p.x + 0.1*random(p);
    float yoff = p.y + 0.1*random(p);
    vec2 pn = vec2(p.x+ 0.1*sin(noize3(0.3*iTime)),p.y+ 0.1*sin(noize3(0.2*iTime)));
    //float rad = ((length(p)) * (1+sin(noize3(0.3*iTime))) );
    float rr = 0.1*(1+sin(noize3(0.3*iTime)));
    rr = 0.1*(1+sin((0.3*iTime)));

    float rad = length(pn) - rr;
    //float noff = randomB(10.*(2+sin(0.1*iTime+PI_HALF))*p);
    float radstep = step(0.1, (rad));
    vec3 col = vec3(radstep );
    col *= noize3(10*(1+sin(rad - 0.16*iTime - 10.*iRandom3)));
    
    gl_FragColor = vec4(step(0.2,col), 1.0);
}
