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
uniform sampler2D texture;

void main( void)
{
    vec2 p = vec2(-1.0) + 2.0*gl_FragCoord.xy/iResolution.xy;

    float r = pow( pow(p.x*p.x,16.0) + pow(p.y*p.y,16.0), 1.0/32.0 );
    float a = atan(p.y,p.x);
    
    vec2 uv = vec2(.5*iTime + 0.5/r, a/3.1415927) ;
	
	float h = sin(32.0*uv.y);
    uv.x += .85*smoothstep( -0.1,0.1,h);

    /*vec3 col = mix( sqrt(texture( iChannel1, 2.0*uv ).xyz),       
                    texture( iChannel0, 1.0*uv ).xyz, 
                    smoothstep(0.9,1.1,abs(p.x/p.y) ) );
	*/

	vec4 col = texture2D( texture, uv );
    vec3 col3 = mix( sqrt(texture2D( texture, uv, 2.0 ).xyz),       
                    texture2D( texture, uv ).xyz, 
                    smoothstep(0.9,1.1,abs(p.x/p.y) ) );

    r *= 1.0 - 0.3*(smoothstep( 0.0, 0.3, h ) - smoothstep( 0.3, 0.96, h ));
	
    gl_FragColor = vec4( col.xyz*r*r*1.2, 1. );
}
