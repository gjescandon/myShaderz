#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER
#define PI 3.14159265359

uniform vec2 u_resolution;
uniform vec3 u_mouse;
uniform float u_time;


void shader1() {
    vec2 st = gl_FragCoord.st/u_resolution;
    gl_FragColor = vec4(st.x,st.y,0.0,1.0);
}


float plot(vec2 st, float pct) {
	
	return smoothstep(pct-0.02, pct, st.y) - smoothstep(pct, pct+0.02, st.y);
}

void main() {
  //shader1();
  
  vec2 st = gl_FragCoord.xy/u_resolution;

  float y = sin(PI * st.x);

  vec3 color = vec3(y);

  // plot line

  float pct = plot(st,y);
  color = (1.0-pct) * color + pct * vec3(0.0,1.0,0.0);

  //if (gl_FragColor != vec3(0.0)) {
    gl_FragColor = vec4(color,1.0);
  //}
}

