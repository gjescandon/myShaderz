#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718 

uniform vec2 iResolution;
//uniform vec2 u_mouse;
uniform float iTime;

//uniform sampler2D texture;

float expStep( float x, float k, float n )
{
    // n : power (positive > 1)
    // k : cross over 1/x
    return exp( -k*pow(x,n) );
}



float ndot( vec2 a, vec2 b) {
    return (a.x*b.x - a.y*b.y);
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

float sdRhombus( vec2 p, vec2 b) {
  vec2 q = abs(p);
  float h = clamp((-2.0*ndot(q,b)+ndot(b,b))/dot(b,b),-1.0,1.0);
  float d = length( q - 0.5*b*vec2(1.0-h,1.0+h));
  return d * sign(q.x*b.y + q.y*b.x - b.x*b.y);

}




void main( void )
{
    
    vec2 p = (2.0*gl_FragCoord.xy-iResolution.xy)/iResolution.y;
    float it = 0.5 * iTime;
    //p.x += 0.8 * cos(0.5* it + 0.0);
    
    float power = 2.;
    float step = 1.;// + 5. * abs(sin(0.3*u_time));
    //p.y -= expStep( p.x, step, power );    
    
    float ySide = 0.4 + 0.3*cos(it + 0.0);
    float xSide = 1/ySide;
    vec2 ra = vec2(0.1, ySide);
    float d = sdBox(p, ra);
    vec3 col = vec3(1.0) - sign(d)*vec3(0.1,0.4,0.7);
    //col = sign(d)*vec3(0.1,0.4,0.7);
     col -= vec3(d); // solo this for burning retina thing
    //col *= 1.0 - exp(-2.0*abs(d));
    //col *= 0.8 + 0.2*cos(140.0*d);
    col = mix(col, vec3(1.0), 1.0-smoothstep(0.0, 0.02, abs(d)));
    gl_FragColor = vec4(col, 1.0);
}
