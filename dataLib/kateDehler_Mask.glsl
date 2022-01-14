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

  
 



  vec3 getColorBW(float t0) {
  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  float a1 = iRandom1;
  float b1 = 0.4; //oscilators amplitude

  float c1 = 1 + floor(10*iRandom1); // sin rate
  

  float d1 = 0.; // offset


  b1 = fract(100*iRandom1);

  d1 = fract(1000*iRandom1);

  
  float b1f = b1 * cos(TWO_PI*(c1*tnom+d1));
  float red1 = clamp((a1 + b1f),0.,iColorLimiter);
  vec3 c = vec3(red1,red1,red1);
  return c;   
 }



float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
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

void main( void )
{
    
  vec2 p = vec2(1.);
	p = (2.0*gl_FragCoord.xy-iResolution.xy)/iResolution.y;
  p.x += 0.2*sin(0.001*iTime + noize3(0.01*iTime) + 10.*iRandom1);
  p.y += 0.05*sin(0.001*iTime + noize3(0.01*iTime) + 10.*iRandom2);
  float aspect = iResolution.x/iResolution.y;

  vec3 col = vec3(1.);
  float rad0 = 1.7;
  float rad = rad0 * expSustainedImpulse(0.01 * (iTime+100*iRandom2), 3.0, 3.0);
  
  
  float radOff = 0.5;
  float iMax = 34.;
  float coff = (iMax-1)/iMax;

  float cd = getExpandingCircle(p, rad);
  //cd = step(0.01, cd);
  col = (1-smoothstep(0.,0.01,cd))*vec3(1.0);


  for (int i = 1; i < iMax; i ++) {
    if (rad-radOff*(i-1) > 0.5) {
      float rrad = rad-i*1.1*radOff;
      
        col -= step(0.1,getExpandingCircle(p, rad)*getExpandingCircle(p, rrad));
      float cdd = getExpandingCircle(p, rrad);
      cdd = step(0.01, cdd);
      if (i % 2 == 0) {
        col += (1-smoothstep(0.,0.01,cdd))*vec3(1.0);
      }
    }
  }
  
  //col = mix( getColor(0.03*iTime), vec3(1.0), 1.0-smoothstep(0.0,0.01,abs(cd)) ); // stroke
  gl_FragColor = vec4(col, 1.0);

}
