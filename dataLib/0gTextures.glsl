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
uniform float iColorLimiter;

uniform sampler2D texture01;
uniform sampler2D texture02;
uniform sampler2D texture03;
uniform sampler2D texture04;


float hash(float x, float y) {
  float ret = sin(x*12.9898 + y*78.233)*43758545.3123;
    return ret - floor(ret);
  }
  
  
  /*
  float random (float[] st) {
      float x2 = 47.5453123 + 10.*sin(0.01*u_time)+ 10.*cos(0.01*u_time);
      return fract(sin(dot(st.xy,
                           vec2(159.9898,78.233)))*
          x2);
  }
  */
  
  float almostIdentity( float x )
  {
      return x*x*(2.0-x);
  }
  
  float almostIdentity( float x, float m, float n )
  {
      // n :: zero value
      // m :: y(m) = x
      //if( x>m ) return x;
      float a = 2.0*n - m;
      float b = 2.0*m - 3.0*n;
      float t = x/m;
      if( x>m ) 
      {
          return x;
      } else {
        return (a*t + b)*t*t + n;
      }
  }
  
  float almostIdentityDos( float x, float n )
  {
      return sqrt(x*x+n);
  }
  
  float cubicPulse( float c, float w, float x )
  {
      // REPLACES smoothstep(c-w,c,x)-smoothstep(c,c+w,x)
      x = abs(x - c);
      //if( x>w ) return 0.0;
      //x /= w;
      //return 1.0 - x*x*(3.0-2.0*x);
      float ret = 0.;
      if (x < w) {
          x /= w;
          ret = 1.0 - x*x*(3.0-2.0*x);
      }
      return ret;
  
  }
  
  float expImpulse( float x, float k )
  {
      float h = k*x;
      return h*exp(1.0-h);
  }
  
  
  
  float expStep( float x, float k, float n )
  {
      // n : power (positive > 1)
      // k : cross over 1/xx
      return exp( -k*pow(x,n) );
  }
  
  
  float expSustainedImpulse( float x, float f, float k )
  {
      // f: release
      // k: attack
      float s = max(x-f,0.0);
      return min( x*x/(f*f), 1+(2.0/f)*s*exp(-k*s));
  }
  
  float gain(float x, float k) 
  {
      float a = 0.5*pow(2.0*((x<0.5)?x:1.0-x), k);
      return (x<0.5)?a:1.0-a;
  }
  
  float parabola( float x, float k )
  {
      return pow( 4.0*x*(1.0-x), k );
  }
  
  float pcurve( float x, float a, float b )
  {
      float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
      return k * pow( x, a ) * pow( 1.0-x, b );
  }
  
  
  float quaImpulse( float k, float x )
  {
      return 2.0*sqrt(k)*x/(1.0+k*x*x);
  }
  
  float sinc( float x, float k )
  {
      float a = PI*(k*x-1.0);
      return sin(a)/a;
  }
 

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
   // **** RGB in here **** 
  float a1 = 0.5; // 

  float b1 = 0.2; //oscilators amplitude

  float c1 = 1.5 * (1 + 0.5* sin(0.01*iTime)); //input amplitude

  float d1 = 0.; // offset

  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  b1 = iRandom1;
  //c1 = iRandom2;
  d1 = iRandom3;

  float h1 = clamp(a1 + b1 * cos(TWO_PI*(c1*tnom+d1)),0.0, 1.0);
  return vec3(h1); //fract(h1);   
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

  
  float b1f = b1 * cos(TWO_PI*(c1*tnom+d1));
  float red1 = clamp(factor * (a1 + b1f),0.,iColorLimiter);
  float b2f = b2 * cos(TWO_PI*(c2*tnom+d2));
  float grn2 = clamp(factor * (a2 + b2f),0.,iColorLimiter);
  float b3f = + b3 * cos(TWO_PI*(c3*tnom+d3));
  float blu3 = clamp(factor * (a3 + b3f),0.,iColorLimiter);
  vec3 c = vec3(red1,grn2,blu3);
  return c;   
 }

vec2 tile(vec2 st, float N) {
   float aspect = iResolution.x/iResolution.y;
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

float ndot( vec2 a, vec2 b) {
    return (a.x*b.x - a.y*b.y);
}

float sdRhombus( vec2 p, vec2 b) {
  vec2 q = abs(p);
  float h = clamp((-2.0*ndot(q,b)+ndot(b,b))/dot(b,b),-1.0,1.0);
  float d = length( q - 0.5*b*vec2(1.0-h,1.0+h));
  return d * sign(q.x*b.y + q.y*b.x - b.x*b.y);

}

vec3 colorClamp(vec3 color) {
    return clamp(color, vec3(0.), vec3(1.));
}

void main( void )
{
    
    vec2 p = (2.0*gl_FragCoord.xy-iResolution.xy)/iResolution.xy; // center around zero

    vec2 ra = 0.5 + 0.4*cos(iTime + vec2(0.0,1.57) + 0.0);
    vec2 ra2 = 0.4 + 0.3*cos(iTime + vec2(0.0,1.57) + 0.0);

    //p +=vec2(p.x*sin(0.25*iTime),p.y*cos(0.25*iTime));
    vec2 p1 = p;
    p1.x += 0.5*sin(0.25*iTime + noize3(0.1*iTime));
    p1.y += 0.5*cos(0.25*iTime + noize3(0.3*iTime));
    vec2 p2 = p;
    p2.x += 0.5*sin(0.25*iTime + PI_HALF + noize3(0.3*iTime));
    p2.y += 0.5*cos(0.25*iTime + PI_HALF + noize3(0.5*iTime));
    vec2 p3 = p;
    p3.x += 0.5*sin(0.25*iTime + 2.*PI_HALF + noize3(0.5*iTime));
    p3.y += 0.5*cos(0.25*iTime + 2.*PI_HALF + noize3(0.7*iTime));
    vec2 p4 = p;
    p4.x += 0.5*sin(0.25*iTime + 3.*PI_HALF + noize3(0.7*iTime));
    p4.y += 0.5*cos(0.25*iTime + 3.*PI_HALF + noize3(0.9*iTime));

    float d = sdRhombus(p1, ra);
    float d2 = sdRhombus(p2, ra2);
    float d3 = sdRhombus(p3, ra);
    float d4 = sdRhombus(p4, ra2);

    vec3 col = clamp(10.*(vec3(1.0) - sign(d)), vec3(0.), vec3(1.));
    vec3 col2 = clamp(10.*(vec3(1.0) - sign(d2)), vec3(0.), vec3(1.));
    vec3 col3 = clamp(10.*(vec3(1.0) - sign(d3)), vec3(0.), vec3(1.));
    vec3 col4 = colorClamp(10.*(vec3(1.0) - sign(d4)));

    vec3 colCross12 = col * col2;
    vec3 colCross13 = col * col3;
    vec3 colCross14 = col * col4;
    vec3 colCross23 = col2 * col3;
    vec3 colCross24 = col2 * col4;
    vec3 colCross34 = col3 * col4;
    vec3 colCross123 = col * col2 * col3;
    vec3 colCross124 = col * col2 * col4;
    vec3 colCross134 = col * col3 * col4;
    vec3 colCross234 = col3 * col2 * col4;

    col = colorClamp(col - colCross12);    
    col = colorClamp(col - colCross13);    
    col = colorClamp(col - colCross14);    
    col = colorClamp(col - colCross123);    
    col = colorClamp(col - colCross134);    
    col = colorClamp(col - colCross124);    

    col3 = colorClamp(col3 - colCross23);    
    col3 = colorClamp(col3 - colCross24);    
    col3 = colorClamp(col3 - colCross34);    
    col3 = colorClamp(col3 - colCross123);    
    col3 = colorClamp(col3 - colCross134);    
    col3 = colorClamp(col3 - colCross234);    
    
    col2 = colorClamp(col2 - colCross24);    
    
    
    col *= texture2D(texture01, p1 + 0.5).xyz;
    col = mix(col, vec3(0.3), 1.0-smoothstep(0.0, 0.02, abs(d)));


    // col -= vec3(d); // solo this for burning retina thing
    //col *= 1.0 - exp(-2.0*abs(d));
    //col *= 0.8 + 0.2*cos(140.0*d); // parallel lines


    col2 *= texture2D(texture02, p2 + 0.5).xyz;
    col2 = mix(col2, vec3(0.3), 1.0-smoothstep(0.0, 0.02, abs(d2)));
    col3 *= texture2D(texture01, p3 + 0.5).xyz;
    col3 = mix(col3, vec3(0.3), 1.0-smoothstep(0.0, 0.02, abs(d3)));
    col4 *= texture2D(texture02, p4 + 0.5).xyz;
    col4 = mix(col4, vec3(0.3), 1.0-smoothstep(0.0, 0.02, abs(d4)));
    
    col += (col2 + col3 + col4);
    //col = col2 + col4;
    gl_FragColor = vec4(col, 1.0);
    
}
