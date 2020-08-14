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

    // make a block of color
    vec2 xyOff = vec2(0.3, 0.4); 
    st += xyOff;
    vec2 lb = step(vec2(0.8), st) * step(st, vec2(1.0));
    color = lb.x * lb.y * vec3(0.0, 0.0, 1.0);
    st -= xyOff;

    st +=  vec2(0.3 * sin(u_time / 10.0));

    // Each result will return 1.0 (white) or 0.0 (black).
    float left = step(0.5,sin(100.0 * st.x));   // toggle the color across X.
    float bottom = step(0.1,st.y); // Similar to ( Y greater than 0.1 )

    //vec2 bl = step(vec2(0.1), st);

    // The multiplication of left*bottom will be similar to the logical AND.
    if (vec3(0.0) == color) {
        color = left * bottom * vec3(0.0, 0.5, 0.5);
    }



    gl_FragColor = vec4(color, 1.0);
}