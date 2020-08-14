// Author: Inigo Quiles
// Title: Expo
#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER
#define PI 3.14159265359
#define TWO_PI 6.28318530718 

uniform vec2 u_resolution;
uniform float u_time;

vec2 tile(vec2 st, float N) {
    st *= N;      // Scale up the space by N
    // Now we have N spaces that goes from 0-1
    return fract(st); // Wrap around 1.0

}

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

float box(vec2 _st, vec2 _size, float _smoothEdges){
    _size = vec2(0.5)-_size*0.5;
    vec2 aa = vec2(_smoothEdges*0.5);
    vec2 uv = smoothstep(_size,_size+aa,_st);
    uv *= smoothstep(_size,_size+aa,vec2(1.0)-_st);
    return uv.x*uv.y;
}

float circle(in vec2 _st, in float _radius){
    vec2 l = _st-vec2(0.5);
    return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(l,l)*6.0);
}

float trishape(vec2 st, int N) {
  st = st *2.-1.;
  // N: Number of sides of your shape

  // Angle and radius from the current pixel
  float a = atan(st.x,st.y)+PI + sin(u_time);
  float r = TWO_PI/float(N);

  // Shaping function that modulate the distance
  float d = cos(floor(.5+a/r)*r-a)*length(st);

  return 1.0-smoothstep(.4,.41,d);
}

void main() {
	vec2 st = gl_FragCoord.xy/u_resolution;
    vec3 color = vec3(0.0);

    //color = vec3(st,0.0);

   // Divide the space in 4
    vec2 pbox = tile(st,4.);

    // Use a matrix to rotate the space 45 degrees
    pbox = rotate2D(pbox,PI*0.25);

    // Draw a square
    color = vec3(box(pbox,vec2(0.7),0.01));


    //color = vec3(circle(tile(st,4),0.5));
    int Ntile = 7;
    int sides = 3;
    float pct = trishape(tile(st, Ntile), sides);
    vec3 colorB = vec3(0.0,0.8,0.2);
    vec3 colorC = vec3(0.5,0.2,0.6);
    color = (1-pct)*color;
    color += pct * (colorB + step(1., mod( Ntile*st.x + step(0.5, abs(sin(u_time))), 2.)) * (colorC - colorB));

	gl_FragColor = vec4(color,1.0);
}