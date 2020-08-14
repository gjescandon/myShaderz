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

float trishapeOut(vec2 st, int N) {
  st = st *2.-1.;
  // N: Number of sides of your shape

  // Angle and radius from the current pixel
  float a = atan(st.x,st.y)+PI + sin(0.3*u_time);
  float r = TWO_PI/float(N);

  // Shaping function that modulate the distance
  float d = sin(floor(.5+a/r)*r-a)*1.6*length(st);

  return 1.0-smoothstep(.4,.41,d);
}

float random (vec2 st) {
    float x2 = 47.5453123 + 10.*sin(0.01*u_time)+ 10.*cos(0.01*u_time);
    return fract(sin(dot(st.xy,
                         vec2(159.9898,78.233)))*
        x2);
}

float random2 (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

mat2 rotateAngle(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

vec2 rotate2D (vec2 _st, float _angle) {
    _st -= 0.5;
    _st =  rotateAngle(_angle) * _st;
    _st += 0.5;
    return _st;
}

vec2 tile (vec2 _st, float _zoom) {
    _st *= _zoom;
    return fract(_st);
}

vec2 rotateTilePattern(vec2 _st){

    //  Scale the coordinate system by 2x2
    _st *= 2.0;

    //  Give each cell an index number
    //  according to its position
    float index = 0.0;
    index += step(1., mod(_st.x,2.0));
    index += step(1., mod(_st.y,2.0))*2.0;

    //      |
    //  2   |   3
    //      |
    //--------------
    //      |
    //  0   |   1
    //      |

    // Make each cell between 0.0 - 1.0
    _st = fract(_st);

    // Rotate each cell according to the index
    if(index == 1.0){
        //  Rotate cell 1 by 90 degrees
        _st = rotate2D(_st,PI*0.5);
    } else if(index == 2.0){
        //  Rotate cell 2 by -90 degrees
        _st = rotate2D(_st,PI*-0.5);
    } else if(index == 3.0){
        //  Rotate cell 3 by 180 degrees
        _st = rotate2D(_st,PI);
    }

    return _st;
}

void main (void) {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    st = tile(st,2.0);
    st = rotateTilePattern(st);

    // Make more interesting combinations
    // st = tile(st,2.0);
    // st = rotate2D(st,-PI*u_time*0.25);
    // st = rotateTilePattern(st*2.);
    // st = rotate2D(st,PI*u_time*0.25);

    // step(st.x,st.y) just makes a b&w triangles
    // but you can use whatever design you want.

    float shapef = step(st.x, 0.9 * (2. + sin(0.3*u_time)) *st.y); 

    //st = 2.*st -1.;
    
    shapef = step(1., st.x/st.y) * ( 1. - step(0.45 + 0.06*abs(sin(0.5*u_time)), distance(st,vec2(0.5))));
    gl_FragColor = vec4(vec3(shapef),1.0);
}