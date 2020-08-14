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



void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    vec2 p = st;
    p = 2.*p - 1.;

    // p = 4.* p;
    float w = 0.01;

    vec2 origin = vec2(0.);
    float r0 = length(p - origin);
    float theta = (PI + atan(p.y, p.x));// * (3 - abs(sin(0.3*u_time)));
    vec3 c = vec3(0.);
    float a = 0.6;
    float N = 4. + floor(3 * sin(0.4*u_time));
    //float b = ((0.05*sin(0.3*u_time))/a) - 0.005;
    float r1 = 0.5 * theta / PI;// + (2 * theta / PI);
    float r2 = 0.5 * (theta+2*PI) / PI;
    float r3 = 0.5 * (theta+4*PI) / PI;
    // REPLACES smoothstep(c-w,c,y)-smoothstep(c,c+w,y)
    float rscale = 0.3;
    r1 *= rscale;
    r2 *= rscale;
    r3 *= rscale;
    c = vec3(cubicPulse(r1,w,r0),cubicPulse(r2,w,r0),cubicPulse(r3,w,r0));
    //c+= vec3(cubicPulse(r1,w,r0))



/*
    // BOTTOM ROW
    float yOff = 0.;
    if (i_st == vec2(0,0)) {
        vec2 p = st;
        p = 2.*p - 1.;

        // p = 4.* p;
        vec2 origin = vec2(0.);
        float r0 = length(p - origin);
        float theta = atan(p.y, p.x);
        vec3 c = vec3(0.);
        float r1 = 0.8*sin(theta);
        float r2= 0.8*cos(theta);
        // REPLACES smoothstep(c-w,c,y)-smoothstep(c,c+w,y)
        c = vec3(cubicPulse(r1,w,r0),cubicPulse(r2,w,r0),cubicPulse(r1+r2,w,r0));
    }
    if (i_st == vec2(1.,0.)) {
        vec2 origin = vec2(0.);
        float r0 = length(p - origin);
        float theta = atan(p.y, p.x);
        vec3 c = vec3(0.);
        float a = 0.2;
        float r1 = a + a*sin(theta);
        float r2= a - a*cos(theta);
        // REPLACES smoothstep(c-w,c,y)-smoothstep(c,c+w,y)
        c = vec3(cubicPulse(r1,w,r0),cubicPulse(r2,w,r0),cubicPulse(r1+r2,w,r0));
    }
    if (i_st == vec2(2.,0.)) {
        float a = 0.3;
        //float b = ((0.05*sin(0.3*u_time))/a) - 0.005;
        float r1 = sqrt(a * a *sin(theta + theta));
        float r2= sqrt(a * a *cos(theta + theta));
        // REPLACES smoothstep(c-w,c,y)-smoothstep(c,c+w,y)
        c = vec3(cubicPulse(r1,w,r0),cubicPulse(r2,w,r0),cubicPulse(r1+r2,w,r0));
    }


    // middle ROW
    yOff += 1.;
    if (i_st == vec2(0,1.)) {
        vec2 origin = vec2(0.);
        float r0 = length(p - origin);
        float theta = atan(p.y, p.x);
        vec3 c = vec3(0.);
        float a = 0.2;
        float b = ((0.05*sin(0.3*u_time))/a) - 0.005;
        float r1 = a + b*sin(theta);
        float r2= a - b*cos(theta);
        // REPLACES smoothstep(c-w,c,y)-smoothstep(c,c+w,y)
        c = vec3(cubicPulse(r1,w,r0),cubicPulse(r2,w,r0),cubicPulse(r1+r2,w,r0));

    }
    if (i_st == vec2(1.,1.)) {
        float a = 0.6;
        float N = 4. + floor(3 * sin(0.4*u_time));
        //float b = ((0.05*sin(0.3*u_time))/a) - 0.005;
        float r1 = a *sin(N * theta);
        float r2 = a *cos(N * theta);
        // REPLACES smoothstep(c-w,c,y)-smoothstep(c,c+w,y)
        c = vec3(cubicPulse(r1,w,r0),cubicPulse(r2,w,r0),cubicPulse(r1+r2,w,r0));

    }

    if (i_st == vec2(2.,1.)) {
        cPy = yOff + almostIdentityDos(f_st.x, 0.06);
        c = vec3(cubicPulse(cPy,w,p.y));
    }


    // TOP ROW
    yOff += 1.;
    if (i_st == vec2(0.,2.)) {
        cPy = yOff + cubicPulse(0.5, 0.35, f_st.x);
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(1.,2.)) {
        float power = 1. + 5. * abs(sin(0.3*u_time));
        float step = 5.;
        cPy = yOff + expStep( f_st.x, step, power );
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(2.,2.)) {
        float power = 4.;
        float step = 1. + 5. * abs(sin(0.3*u_time));
        cPy = yOff + expStep( f_st.x, step, power );
        c = vec3(cubicPulse(cPy,w,p.y));

*/
    gl_FragColor = vec4(c,1.0);


}

