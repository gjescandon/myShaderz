#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718 

uniform vec2 u_resolution;
//uniform vec2 u_mouse;
uniform float u_time;

uniform sampler2D texture;


float f(vec3 p) 
{ 
	p.z+=u_time;
  return length(.05*cos(9.*p.y*p.x)+cos(p)-.1*cos(9.*(p.z+.3*p.x-p.y)))-1.; 
}




void main( void )
{

  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  vec2 p = st;//-vec2(0.5);


    vec3 d=.5-vec3(p,1)/u_resolution.x;
    vec3 o=d;
    for(int i=0;i<128;i++) o+=f(o)*d;
    vec4 c0 = vec4(1.0);
    //c0.xyz = abs(f(o-d)*vec3(0,1,2)+f(o-.6)*vec3(2,1,0))*(1.-.1*o.z),1.0;
    c0.xyz = abs(f(o-d)*vec3(0,1,2)+f(o-.6)*vec3(2,1,0))*(1.-.1*o.z),1.0;
    gl_FragColor = c0;
}
