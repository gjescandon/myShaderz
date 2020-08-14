// Author: Inigo Quiles
// Title: Expo
#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER
#define PI 3.14159265359
#define TWO_PI 6.28318530718 

uniform vec2 u_resolution;
uniform vec3 u_mouse;
uniform float u_time;

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color = vec3(0.0);

    // Each result will return 1.0 (white) or 0.0 (black).
    float left = step(0.1,st.x);   // Similar to ( X greater than 0.1 )
    float bottom = step(0.1,st.y); // Similar to ( Y greater than 0.1 )

    vec2 bl = step(vec2(0.1), st);

    // The multiplication of left*bottom will be similar to the logical AND.
    color = vec3( left * bottom );

    color = vec3(bl.x * bl.y);
    color += vec3(0.0, 0.5, 0.5); // convert blacks to colors
    
    gl_FragColor = vec4(color,1.0);
}