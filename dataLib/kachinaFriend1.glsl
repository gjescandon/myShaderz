// Author: Inigo Quiles
// Title: Expo
#ifdef GL_ES
precision mediump float;
#endif

// https://www.iquilezles.org/www/articles/functions/functions.htm

#define PROCESSING_COLOR_SHADER
#define PI 3.14159265359
#define TWO_PI 6.28318530718 
#define MAX_STEPS 100
#define SURFACE_DIST 0.01
#define MAX_DIST 100.

uniform vec2 u_resolution;
uniform float u_time;


float random (vec2 st) {
    float x2 = 43758.5453123;

    //x2 +=  + 10.*sin(0.01*u_time)+ 10.*cos(0.01*u_time);
    return fract(sin(dot(st.xy,
                         vec2(159.9898,78.233)))*
        x2);
}

float noise( vec2 st) {
    return random(st);
}

/*
float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0;

    return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
               mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
}
*/


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

float gain(float x, float k) 
{
    float gainMid = 0.9;
    float a = gainMid*pow(2.0*((x<gainMid)?x:1.0-x), k);
    return (x<gainMid)?a:1.0-a;
}

float sinc( float x, float k )
{
    float a = PI*(k*x-1.0);
    return sin(a)/a;
}

mat2 m = mat2(0.8, 0.6, -.6, 0.8); // rotation matrix

float fbm(vec2 p) {
    float f = 0.;
    f+= 0.5*noiseValue(p);
    p*= m*2.02;
    f+= 0.25*noiseValue(p);
    p*= m*2.03;
    f+= 0.125*noiseValue(p);
    p*= m*2.01;
    f+= 0.0625*noiseValue(p);
    p*= m*2.04;
    f /= 0.9375;
    return f;
    
}

float trishape(vec2 st, int N) {
  //st = st *2.-1.;
  // N: Number of sides of your shape

  // Angle and radius from the current pixel
  float a = atan(st.x,st.y)+PI;
  float r = TWO_PI/float(N);

  // Shaping function that modulate the distance
  float d = cos(floor(.5+a/r)*r-a)*length(st);

  return 1.0-smoothstep(.4,.41,d);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st *= vec2(u_resolution.x/u_resolution.y,1.0); // fix aspect resolution)
    vec2 p = 2.0*st -1.;

    vec2 pbkgd = 10.*p;
    pbkgd.x += 0.1*pbkgd.x*sin( 0.05*pbkgd.y * PI - 0.5 * PI);
    pbkgd.y += 0.1*pbkgd.y*sin( 0.05*pbkgd.x * PI - 0.5 * PI);


    float background = smoothstep (-08.5, -8., pbkgd.x);
    background *= 1- smoothstep (8., 8.5, pbkgd.x);
    background *= 1- smoothstep (8., 8.5, pbkgd.y);
    background *= smoothstep (-08.5, -8., pbkgd.y);
    vec3 col = vec3(1.);
    col = vec3(0., 0.3, 0.4);
    float fbk = fbm(5.*pbkgd);  // blue face
    col = mix (col, vec3(0.2, 0.5, 0.4), fbk+0.2*sin(0.9*u_time));


    // eyeballs
    vec2 peye = vec2(abs(p.x), p.y) + vec2(-.4+ 0.01*noise(p), -.3+ 0.01*noise(p));
    
    float r = length (peye);
    float a = atan(peye.y/peye.x);;
    float rMax = 0.3;


    float ss = 0.5+0.5*sin(0.6 * u_time );
    float anim = 1. + 0.1*ss*clamp(1.-r,0.,1.);
    r *= anim;


    if (r < rMax){
        col = vec3(0., 0., 0.);
        
        float f = fbm(10.*peye);  // black eye
        col = mix (col, vec3(0.0, 0.0, 0.4), f);

        f = 1-smoothstep(.25, .29, r); // yellow weird ring
        col = mix(col, vec3(0.7, 0.4, 0.0) , f);

        a += (0.2 + 0.05*sin(0.08*u_time)) * fbm(10.*p); // domain deform angle of rays
        float rOff = 0.1*(4. + 2.*sin(0.2*u_time));
        float aOff = 2. + (1. + 5.*sin(.2*u_time));
        f = smoothstep(0.2, 0.99, fbm(vec2(r*rOff, a*aOff)));
        f = smoothstep(0.05, 1.0, fbm(vec2(r*rOff, a*aOff)));
        f = smoothstep(0.05, 1.0, fbm(10.* rOff * peye));
        
        if (r < 0.9*rMax) {
            col = mix(col,vec3(0.8), f);
        }
        //f = smoothstep(0.1, 0.6, fbm(vec2(rOff*r, 10.*a)));
        //col *= 1- f ;
/*
        f = smoothstep(0.5, 0.8, r);
        col *= 1.-0.5*f;

        f = smoothstep(0.2, 0.3, r); // iris
        col *= f;
        
        f = smoothstep(rMax-0.02, rMax,r);
        col = mix(col,vec3(1.),f);
        */
    }



    // red mouth
    vec2 pm = vec2(p.x, 1.3*p.y + 0.45);
    //pm  += vec2(-.4+ 0.01*noise(p), -.3+ 0.01*noise(p));
    // gain on x
    float gainX = 2.;
    pm.x = 0.06*gain(pm.x, gainX);
    pm.y += 1.35*abs(pm.y)*sin(1.5*pm.x * PI + 0.5*PI);

    float rm = length (pm) + 0.1*noise(pm)*(0.4+ 0.5*abs(sin(0.2*u_time)));
    float am = atan(pm.y/pm.x);;
    float rmMax = 0.17;


    float rm_ss = 0.5+0.5*sin(1.9 * u_time );
    float rm_anim = 1. + 0.1*rm_ss*clamp(1.-r,0.,1.);
    rm *= rm_anim;


    if (rm < rmMax){
        col = vec3(0., 0., 0.);
        
        float f = fbm(10.*peye);  // red mouth
        col = mix (vec3(0.1,0,0), vec3(0.4, 0.0, 0.2), f);

        f = 1-smoothstep(.25, .29, rm); // yellow weird ring
        //col = mix(col, vec3(0.7, 0.4, 0.0) , f);

/*
        a += (0.2 + 0.05*sin(0.08*u_time)) * fbm(10.*p); // domain deform angle of rays
        float rOff = 0.1*(4. + 2.*sin(0.2*u_time));
        float aOff = 2. + (1. + 5.*sin(.2*u_time));
        f = smoothstep(0.2, 0.99, fbm(vec2(r*rOff, a*aOff)));
        f = smoothstep(0.05, 1.0, fbm(vec2(r*rOff, a*aOff)));
        f = smoothstep(0.05, 1.0, fbm(10.* rOff * peye));
        
        if (r < 0.9*rMax) {
            col = mix(col,vec3(0.8), f);
        }
        //f = smoothstep(0.1, 0.6, fbm(vec2(rOff*r, 10.*a)));
        //col *= 1- f ;

        f = smoothstep(0.5, 0.8, r);
        col *= 1.-0.5*f;

        f = smoothstep(0.2, 0.3, r); // iris
        col *= f;
        
        f = smoothstep(rMax-0.02, rMax,r);
        col = mix(col,vec3(1.),f);
        */
    }

    // bottom teeth
    vec2 pt = 5.*vec2(p.x,p.y+0.6);    
    pt.x = p.x * 3.;
    pt.y += 0.2*pt.y*sin( 0.8*pt.x * PI + 0.5 * PI);
    float f = trishape(pt, 3);
    
    float ft = 0.6*noise(80.*pt);
    vec3 cteeth1 = vec3(0.6, 0.4,0.2);
    vec3 cteeth2 = vec3(0.6, 0.1,0.1);
    vec3 cteeth = mix(cteeth1, cteeth2,ft);
    col +=  f * cteeth;
    
    vec2 pt2 = 1.8 * vec2(abs(pt.x) - 1.1, pt.y+0.2);
    pt2.y += 0.2*pt2.y*sin( 0.8*pt2.x * PI + 0.8 * PI);
    f = trishape(pt2, 3);
    
    ft = 0.6*noise(20.*pt2);
    cteeth = mix(cteeth1, cteeth2, ft);
    col +=  f * cteeth;
    
    // upper teeth
    vec2 ptups = vec2(p.x,1.1*p.y);
    ptups = 3.5*vec2((abs(ptups.x)-0.2) ,ptups.y+0.3);
    ptups.y *= -1.;
    ptups.y += 0.1*ptups.y*sin( 0.8*ptups.x * PI - 0.5 * PI);
    f = trishape(ptups, 3);
    ft = 0.6*noise(20.*pt2);
    cteeth = mix(cteeth1, cteeth2, ft);
    col +=  f * cteeth;
    
    vec2 ptups2 = vec2(p.x,p.y);
    ptups2 = 6.5*vec2((abs(ptups2.x)-0.5) ,ptups2.y+0.26);
    ptups2.y *= -1.;
    ptups2.y += 0.3*ptups2.y*sin( 0.6*ptups2.x * PI  - 0.18  * PI);
    f = trishape(ptups2, 3);
    ft = 0.6*noise(20.*pt2);
    cteeth = mix(cteeth1, cteeth2, ft);
    col +=  f * cteeth;
    
    gl_FragColor = vec4(col * background,1.0);


}

