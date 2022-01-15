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

uniform sampler2D texture01;
uniform sampler2D texture02;
uniform sampler2D texture03;
uniform sampler2D texture04;


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
  float b2 = 0.5;
  float b3 = 0.3;

  float c1 = 1.0; //input amplitude
  float c2 = 1.0;
  float c3 = 1.0;

  float d1 = 0.; // offset
  float d2 = 0.3;
  float d3 = 0.6;

  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  a1 = iRandom1;
  a2 = iRandom2;
  a3 = iRandom3;

  d1 = iRandom1 * (1 + 0.1*iTime);
  d2 = iRandom2 * (1 + 0.1*iTime);
  d3 = iRandom3 * (1 + 0.1*iTime);

  b1 = iRandom3;
  b2 = iRandom1;
  b3 = iRandom2;

  c1 *= floor(10*iRandom3);
  c2 *= floor(10*iRandom1);
  c3 *= floor(10*iRandom2);

  
  float b1f = b1 * cos(TWO_PI*(c1*tnom+d1));
  float red1 = clamp((a1 + b1f), 0.2, 0.8);
  float b2f = b2 * cos(TWO_PI*(c2*tnom+d2));
  float grn2 = clamp((a2 + b2f), 0.2, 0.8);
  float b3f = + b3 * cos(TWO_PI*(c3*tnom+d3));
  float blu3 = clamp((a3 + b3f), 0.2, 0.8);
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
    
    vec2 p = vec2(1.);
    //p = ((2.0+sin(0.03*iTime))*gl_FragCoord.xy-iResolution.xy)/iResolution.y;
    p = gl_FragCoord.xy/iResolution.xy - vec2(0.5);


    // background stripes

    float bobSin = sin(0.04*iTime);
    float bobTim = 0.007*iTime;


    float bob = 0.03*random(p);
    float xoff = p.x;// + 0.1*random(p);
    float yoff = p.y;// + 0.1*random(p);
    float rad = fract(xoff * xoff + yoff * yoff) + 0.2*random(p)*(1.5-sin(0.01*iTime));
    rad -= 0.006*iTime;

    vec3 col = vec3(getColor(p.x));
    col = vec3(getColor(fract(p.x*(1+0.4*sin(PI*p.y)) + 0.1*sin(PI*p.y+ 0.1*iTime ) + 0.01*iTime )));
    

    //textures

    vec2 ra = 0.5 + 0.4*cos(0.5*iTime + vec2(0.0,1.57) + 0.0);
    vec2 ra2 = 0.4 + 0.3*cos(0.5*iTime + vec2(0.0,1.57) + 0.0);

    //p +=vec2(p.x*sin(0.25*iTime),p.y*cos(0.25*iTime));
    vec2 p1 = p;
    p1.x += 0.3*sin(0.1*iTime + noize3(0.05*iTime));
    p1.y += 0.3*cos(0.1*iTime + noize3(0.1*iTime));
    vec2 p2 = p;
    p2.x += 0.3*sin(0.1*iTime + PI_HALF + noize3(0.1*iTime));
    p2.y += 0.3*cos(0.1*iTime + PI_HALF + noize3(0.2*iTime));
    vec2 p3 = p;
    p3.x += 0.3*sin(0.1*iTime + 2.*PI_HALF + noize3(0.2*iTime));
    p3.y += 0.3*cos(0.1*iTime + 2.*PI_HALF + noize3(0.3*iTime));
    vec2 p4 = p;
    p4.x += 0.3*sin(0.1*iTime + 3.*PI_HALF + noize3(0.3*iTime));
    p4.y += 0.3*cos(0.1*iTime + 3.*PI_HALF + noize3(0.4*iTime));

    float d = sdRhombus(p1, ra);
    float d2 = sdRhombus(p2, ra2);
    float d3 = sdRhombus(p3, ra);
    float d4 = sdRhombus(p4, ra2);

    vec3 col1 = clamp(10.*(vec3(1.0) - sign(d)), vec3(0.), vec3(1.));
    vec3 col2 = clamp(10.*(vec3(1.0) - sign(d2)), vec3(0.), vec3(1.));
    vec3 col3 = clamp(10.*(vec3(1.0) - sign(d3)), vec3(0.), vec3(1.));
    vec3 col4 = colorClamp(10.*(vec3(1.0) - sign(d4)));

    vec3 colCross12 = col1 * col2;
    vec3 colCross13 = col1 * col3;
    vec3 colCross14 = col1 * col4;
    vec3 colCross23 = col2 * col3;
    vec3 colCross24 = col2 * col4;
    vec3 colCross34 = col3 * col4;
    vec3 colCross123 = col1 * col2 * col3;
    vec3 colCross124 = col1 * col2 * col4;
    vec3 colCross134 = colCross12 * col3 * col4;
    vec3 colCross234 = col3 * col2 * col4;

    col1 = colorClamp(col1 - colCross12);    
    col1 = colorClamp(col1 - colCross13);    
    col1 = colorClamp(col1 - colCross14);    
    col1 = colorClamp(col1 - colCross123);    
    col1 = colorClamp(col1 - colCross134);    
    col1 = colorClamp(col1 - colCross124);    

    col *= (1 - col1);   

    col3 = colorClamp(col3 - colCross23);    
    col3 = colorClamp(col3 - colCross24);    
    col3 = colorClamp(col3 - colCross34);    
    col3 = colorClamp(col3 - colCross123);    
    col3 = colorClamp(col3 - colCross134);    
    col3 = colorClamp(col3 - colCross234);    
    
    col *= (1 - col3);
    //col1 = clamp(10.*(vec3(1.0) - sign(d)), vec3(0.), vec3(1.));

    col2 = colorClamp(col2 - colCross12);    
    col2 = colorClamp(col2 - colCross23);    
    col2 = colorClamp(col2 - colCross24);    
    col2 = colorClamp(col2 - colCross123);    
    col2 = colorClamp(col2 - colCross124);    
    col2 = colorClamp(col2 - colCross234);    
    col *= (1 - col2);

    col2 = clamp(10.*(vec3(1.0) - sign(d2)), vec3(0.), vec3(1.));
    col2 = colorClamp(col2 - colCross24);    // reset here
    
    col4 = colorClamp(col4 - colCross14);    
    col4 = colorClamp(col4 - colCross34);    
    col4 = colorClamp(col4 - colCross24);    
    col4 = colorClamp(col4 - colCross134);    
    col4 = colorClamp(col4 - colCross124);    
    col4 = colorClamp(col4 - colCross234);    
    col *= (1 - col4);

    col4 = colorClamp(10.*(vec3(1.0) - sign(d4))); //reset here


    col1 *= texture2D(texture01, vec2(p1.x+0.5, (-1*p1.y+0.5))).xyz;
    col1 = mix(col1, vec3(0.3), 1.0-smoothstep(0.0, 0.02, abs(d)));

    // col -= vec3(d); // solo this for burning retina thing
    //col *= 1.0 - exp(-2.0*abs(d));
    //col *= 0.8 + 0.2*cos(140.0*d); // parallel lines


    col2 *= texture2D(texture02, p2 + 0.5).xyz;
    //col2 = mix(col2, vec3(0.3), 1.0-smoothstep(0.0, 0.02, abs(d2)));

    col3 *= texture2D(texture03, p3 + 0.5).xyz;
    col3 = mix(col3, vec3(0.3), 1.0-smoothstep(0.0, 0.02, abs(d3)));

    col4 *= texture2D(texture04, vec2(p4.x + 0.5, -1.0*p4.y + 0.5)).xyz;
    //col4 = mix(col, vec3(0.3), 1.0-smoothstep(0.0, 0.02, abs(d4)));
    
    col += (col1 + col2 + col3 + col4);
    gl_FragColor = vec4(col, 1.0);
}
