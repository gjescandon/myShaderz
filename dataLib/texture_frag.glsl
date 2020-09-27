#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718 

uniform vec2 u_resolution;
//uniform vec2 u_mouse;
uniform float u_time;

uniform sampler2D texture;


vec2 renderDeformation( vec2 st ) {
    float x = 0.;
    float y = 0.;
    x =  -1.00f + 2.00*st.x;
    y = -1.00f + 2.00*st.y;
    float d = sqrt( x*x + y*y );
    float a = atan( y, x );

    // magic formulas here
    float offset = 0.06*u_time;
    float r = d + sin(offset);
    float u = cos( a )/r;  // horizon infinity
    float v = sin( a )/r;

    //u = 0.1*x/(0.11+r*0.5); // horizon split
    //v = 0.1*y/(0.11+r*0.5);

    //u = 0.02*y+0.03*cos(a*3)/r; // yin yang pattern
    //v = 0.02*x+0.03*sin(a*3)/r;

    //u = 0.5*a/PI; // cirular bullseye pattern
    //v = sin(3*r);
    return vec2(fract( u ),fract( v ));

}


void main( void )
{
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    vec2 uv = renderDeformation(st);
    vec4 co = texture2D( texture, uv.xy );
    gl_FragColor = co;
}
