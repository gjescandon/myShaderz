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

float expImpulse( float x, float k )
{
    float h = k*x;
    return h*exp(1.0-h);
}



float expStep( float x, float k, float n )
{
    // n : power (positive > 1)
    // k : cross over 1/x
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

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    vec2 p = 4.* st;
    vec2 i_st = floor(p);
    vec2 f_st = fract(p);
    vec3 c = vec3(0.);

    // REPLACES smoothstep(c-w,c,y)-smoothstep(c,c+w,y)

    float w = 0.02;
    float cPy = st.y;

 
   /*
    cPy = almostIdentity(st.x,0.2,0.1);
    cPy = cubicPulse(0.5, 0.35, f_st.x);
        float attack = 6.;
        float release = 0.2;    
    cPy = 0.5*expSustainedImpulse(st.x, release, attack);

    float power = 3.;
    float step = 5.;
    cPy = expStep(st.x, step, power);
    c = vec3(0,0,cubicPulse(cPy,w,st.y));
    c += vec3(cubicPulse(st.y,w,st.x), 0,0);

*/
    // BOTTOM ROW
    float yOff = 0.;
    if (i_st == vec2(0,0)) {
        float k0 = 10.-10.*abs(sin(0.3*u_time));
        cPy = parabola(f_st.x, k0);
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(1.,0.)) {
        cPy = almostIdentity(f_st.x);
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(2.,0.)) {
        cPy = expImpulse(f_st.x, 20.);
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(3.,0.)) {
        float a0 = 10.* abs(sin(0.3*u_time));
        float b0 = 10.* abs(cos(0.3*u_time));
        cPy = pcurve( f_st.x, a0, b0 );
        c = vec3(cubicPulse(cPy,w,p.y));
    }

    // 2ND FROM BOTTOM ROW
    yOff += 1.;
    if (i_st == vec2(0,1.)) {
        float offset = 200. - 180.*abs(sin(0.3*u_time));
        cPy = yOff + quaImpulse(offset, f_st.x);
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(1.,1.)) {
        float pOff = 0.5;
        float p2y = 1.5 * p.y - 0.3;
        float k0 = 5. + 5. * abs(sin(0.3*u_time));
        cPy = yOff + pOff + sinc( f_st.x, k0);
        c = vec3(cubicPulse(cPy,w,p2y));
    }

    if (i_st == vec2(2.,1.)) {
        cPy = yOff + almostIdentityDos(f_st.x, 0.06);
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(3.,1.)) {
        float attack = 7. + sin(0.4*u_time);
        float release = .09 + 0.02* sin(0.3*u_time);   
        cPy = yOff + 0.4*expSustainedImpulse(f_st.x, release, attack);
        c = vec3(cubicPulse(cPy,w,p.y));
    }


    // 2ND FROM TOP ROW
    yOff += 1.;
    if (i_st == vec2(0,2.)) {
        float ss = sin(0.4*u_time);
        cPy = yOff + gain(f_st.x, ss); 
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(1.,2.)) {
        float ss = 1+ 3.*abs(sin(0.3*u_time));
        cPy = yOff + gain(f_st.x, ss); 
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(2.,2.)) {
        float offset = 0.602 - 0.6*abs(sin(0.4*u_time));
        cPy = yOff + almostIdentityDos(f_st.x, offset);
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(3.,2.)) {
        float attack = 20.;//12. - 11.*abs(sin(0.3*u_time));
        float release = 0.25 + 0.2*sin(0.4*u_time);    
        cPy = yOff + 0.5*expSustainedImpulse(f_st.x, release, attack);
        c = vec3(cubicPulse(cPy,w,p.y));
    }

    // TOP ROW
    yOff += 1.;
    if (i_st == vec2(0.,3.)) {
        cPy = yOff + cubicPulse(0.5, 0.35, f_st.x);
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(1.,3.)) {
        float power = 1. + 5. * abs(sin(0.3*u_time));
        float step = 5.;
        cPy = yOff + expStep( f_st.x, step, power );
        c = vec3(cubicPulse(cPy,w,p.y));
    }
    if (i_st == vec2(2.,3.)) {
        float power = 4.;
        float step = 1. + 5. * abs(sin(0.3*u_time));
        cPy = yOff + expStep( f_st.x, step, power );
        c = vec3(cubicPulse(cPy,w,p.y));
    }    if (i_st == vec2(3.,3.)) {
        cPy = yOff + cubicPulse(0.5, 0.35, f_st.x);
        c = vec3(cubicPulse(cPy,w,p.y));
    }


    gl_FragColor = vec4(c,1.0);

}

