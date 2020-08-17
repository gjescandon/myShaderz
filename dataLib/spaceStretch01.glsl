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
    float x2 = 47.5453123 + 10.*sin(0.01*u_time)+ 10.*cos(0.01*u_time);
    return fract(sin(dot(st.xy,
                         vec2(159.9898,78.233)))*
        x2);
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


void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    vec2 p = 20.*st;
    p.y = 20.*st.y - 10.;
    p.x = 20.*st.x - 10.;
    
    //p.x += cubicPulse( 10. + 5.*sin(0.3*u_time), 3., p.y );
    //p.y += cubicPulse( 10. + 5.*cos(0.3*u_time), 3., p.x );
    p.x += 0.1*p.x*sin( 0.05*p.y * PI - 0.5 * PI);
    p.y += 0.1*p.y*sin( 0.05*p.x * PI - 0.5 * PI);
    //p.y += cubicPulse( 10. , 3., p.x );

    vec2 i_st = floor(p);
    vec2 f_st = fract(p);
    vec3 c = vec3(0.);
    float width = 0.06;

    c += vec3(cubicPulse( i_st.x, width, p.x )+cubicPulse( i_st.y, width, p.y ));

    gl_FragColor = vec4(c,1.0);


}

