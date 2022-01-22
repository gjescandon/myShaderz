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
uniform float[100] iRarr;
uniform float iColorLimiter;
  
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

  
 






  vec3 getColor(float t0, float offset) {
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

  a1 = fract(10*iRandom1 * offset);
  a2 = fract(10*iRandom2* offset);
  a3 = fract(10*iRandom3* offset);

  b1 = fract(100*iRandom1* offset);
  b2 = fract(100*iRandom2* offset);
  b3 = fract(100*iRandom3* offset);

  d1 = fract(1000*iRandom1* offset);
  d2 = fract(1000*iRandom2* offset);
  d3 = fract(1000*iRandom3* offset);

  
  float b1f = b1 * cos(TWO_PI*(c1*tnom+d1));
  float red1 = clamp(factor * (a1 + b1f),0.,1.);
  float b2f = b2 * cos(TWO_PI*(c2*tnom+d2));
  float grn2 = clamp(factor * (a2 + b2f),0.,1.);
  float b3f = + b3 * cos(TWO_PI*(c3*tnom+d3));
  float blu3 = clamp(factor * (a3 + b3f),0.,1.);
  vec3 c = vec3(red1,grn2,blu3);
  return c;   
 }

  vec3 getColor(float t0) {
    return (getColor(t0, 1.));
  }

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}


float sdBoxNoise( in vec2 p, in vec2 b )
{
  vec2 bn = vec2(b.x+0.3*random2(p)*sin((0.5*iTime)),b.y+0.3*random2(p)*cos((0.2*iTime)));
  vec2 poff = (2.+iRandom3)*p + 0.1*iRandom2*iTime;
  bn = vec2(b.x+0.3*noiseValue(poff),b.y+0.3*noiseValue(poff));
    vec2 d = abs(p)-bn;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
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


float sdEquilateralTriangle( in vec2 p )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - 1.0;
    p.y = p.y + 1.0/k;
    if( p.x+k*p.y>0.0 ) p = vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0, 0.0 );
    return -length(p)*sign(p.y);
}


float sdTriangle( in vec2 p, in vec2 p0, in vec2 p1, in vec2 p2 )
{
    vec2 e0 = p1-p0, e1 = p2-p1, e2 = p0-p2;
    vec2 v0 = p -p0, v1 = p -p1, v2 = p -p2;
    vec2 pq0 = v0 - e0*clamp( dot(v0,e0)/dot(e0,e0), 0.0, 1.0 );
    vec2 pq1 = v1 - e1*clamp( dot(v1,e1)/dot(e1,e1), 0.0, 1.0 );
    vec2 pq2 = v2 - e2*clamp( dot(v2,e2)/dot(e2,e2), 0.0, 1.0 );
    float s = sign( e0.x*e2.y - e0.y*e2.x );
    vec2 d = min(min(vec2(dot(pq0,pq0), s*(v0.x*e0.y-v0.y*e0.x)),
                     vec2(dot(pq1,pq1), s*(v1.x*e1.y-v1.y*e1.x))),
                     vec2(dot(pq2,pq2), s*(v2.x*e2.y-v2.y*e2.x)));
    return -sqrt(d.x)*sign(d.y);
}



float getExpandingCircle(vec2 p, float rad) {
  float cd = sdCircleNoize(p, rad);
  //cd = sdCircle(p, rad);
  float noff = noiseValue(10.*rad*(2+sin(0.1*iTime+PI_HALF))*p);
  cd = cd-0.2*noff;
  if (rad > 2.) {
    cd = 2 * cd / rad;
  }

  return cd; // solid circle


}

float expStep( float x, float k, float n )
{
    return exp( -k*pow(x,n) );
}

float expStepForCircle( float x )
{
    float k = 0.3;  // max rad
    float n = 4.;
    return expStep(x, k, n);
}

float expSustainedImpulse( float x, float f, float k )
{
    float s = max(x-f,0.0);
    return min( x*x/(f*f), 1+(2.0/f)*s*exp(-k*s));
}

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

mat2 rotate2d(vec2 vi, vec2 vo){
  float c = dot(vi, vo);// cos(_angle)
  float s = length(cross(vec3(vi.x, vi.y, 0.), vec3(vo.x, vo.y, 0.))); // sin(_angle)
    return mat2( c,-s,
                s, c);
}


void main( void )
{
    
  vec2 p = vec2(1.);
	p = (2.0*gl_FragCoord.xy-iResolution.xy)/iResolution.y;
  vec2 p1 = p;
  vec2 p2 = p;
  vec2 p3 = p;
  //TODO: ROTATE P
  p1 = p * rotate2d(vec2(1.,0.), vec2(1.));
  //p1.x -= 1.3;
  p1.y += 2.2; //+ 0.1*sin(0.001*iTime);

  p2 = p * rotate2d(vec2(1.,0.), vec2(1.));
  //p1.x -= 1.3;
  float p2off = 0.9+ 0.1*sin(0.001*iTime + iRandom2);
  p2 += vec2(p2off, 0-p2off);

  p3 = p * rotate2d(vec2(1.,0.), vec2(1.));
  //p1.x -= 1.3;
  p3 -= 0.9; // + 0.1*sin(0.001*iTime + iRandom3);

  float aspect = iResolution.x/iResolution.y;

  vec3 col = vec3(.0);
  
  float sdt1 = sdBoxNoise(p1, vec2(2.1));
  float sdt2 = sdBoxNoise(p2, vec2(1.2));
  float sdt3 = sdBoxNoise(p3, vec2(1.2));
  col += fract((1.-sign(sdt1))*getColor(iRandom3 + 0.03*random2(p) + 0.3*sin(0.1*iTime), iRandom3));
  //sdt = sdTriangle(p, vec2(0.), vec2(1.3,1.3), vec2(1.3, -1.3)); // sdt2
  col += fract((1.-sign(sdt2))*getColor(iRandom1 + 0.03*random2(p) + 0.3*sin(0.1*iTime+ iRandom1), iRandom1));
  //sdt = sdTriangle(p, vec2(0.), vec2(-1.3,1.3), vec2(1.3, 1.3)); // sdt2
  col += fract((1.-sign(sdt3))*getColor(iRandom2 + 0.03*random2(p) + 0.3*sin(0.1*iTime+ iRandom2), iRandom2));
  gl_FragColor = vec4(col, 1.0);

}
