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
void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st *= vec2(u_resolution.x/u_resolution.y,1.0); // fix aspect resolution)
    vec2 p = 2.0*st -1.;

    float background = smoothstep (-0.85, -0.65, p.x);
    vec3 col = vec3(1.);

	float f = 0.0;

    float r = length (p);
    float a = atan(p.y/p.x);;
    float rMax = 0.8;


    float ss = 0.5+0.5*sin(1.9*u_time);
    float anim = 1. + 0.1*ss*clamp(1.-r,0.,1.);
    r *= anim;

    if (r < rMax){
        col = vec3(0., 0.3, 0.4);
        float f = fbm(10.*p);  // blue eye
        col = mix (col, vec3(0.2, 0.5, 0.4), f);

        f = 1.-smoothstep(0.2, 0.5, r); // yellow weird ring
        col = mix(col, vec3(0.9, 0.6, 0.2), f);

        a += (0.05 + 0.02*sin(0.05*u_time)) * fbm(20.*p); // domain deform angle of rays
        float rOff = 4. + 2.*sin(0.2*u_time);
        float aOff = 30. + 5.*sin(0.1*u_time);
        f = smoothstep(0.1, 0.9, fbm(vec2(2.*r, aOff*a)));
        col = mix(col,vec3(1.), f);
        f = smoothstep(0.1, 0.9, fbm(vec2(rOff*r, 10.*a)));
        col *= 1-f;

        f = smoothstep(0.5, 0.8, r);
        col *= 1.-0.5*f;

        f = smoothstep(0.2, 0.3, r); // iris
        col *= f;
        
        f = smoothstep(rMax-0.02, rMax,r);
        col = mix(col,vec3(1.),f);
    }


    gl_FragColor = vec4(col * background,1.0);


}

