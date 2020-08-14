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

//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                             6.0)-3.0)-1.0,
                     0.0,
                     1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix( vec3(1.0), rgb, c.y);
}

float plotA (vec2 st) {
    vec2 p = st;
    //p = vec2(mod(3.*st.x,1.), st.y);
    vec2 area3B = step(vec2(0.4, 0.2), p);
    
    vec2 area3A = vec2(1.);
    area3A= step(vec2(0.4,0.2), 1.-p);
    return area3A.x * area3A.y * area3B.x * area3B.y;
}

float plotB (vec2 st) {
    vec2 p = st;
    p = vec2(mod(3.*st.x,1.), st.y);
    vec2 area3B = step(vec2(0.4, 0.3), p);
    
    vec2 area3A = vec2(1.);
    area3A= step(vec2(0.4,0.3), 1.-p);
    return area3A.x * area3A.y * area3B.x * area3B.y;
}

float plotC1 (vec2 st) {
    vec2 p = st;
    //p = vec2(mod(2.*st.x,1.), st.y);
    vec2 area3B = step(vec2(0.4, 0.1), p);
    
    vec2 area3A = vec2(1.);
    area3A= step(vec2(0.4,0.1), 1.-p);
    return area3A.x * area3A.y * area3B.x * area3B.y;
}

float plotC2 (vec2 st) {
    vec2 p = st;    
    vec2 area3B = step(vec2(0.0, 0.25), p);
    
    vec2 area3A = vec2(1.);
    area3A= step(vec2(0.0,0.5), 1.-p);
    return area3A.x * area3A.y * area3B.x * area3B.y;
}

float plotC3 (vec2 st) {
    vec2 p = st;    
    vec2 area3B = step(vec2(0.0, 0.5), p);
    
    vec2 area3A = vec2(1.);
    area3A= step(vec2(0.0,0.25), 1.-p);
    return area3A.x * area3A.y * area3B.x * area3B.y;
}

vec3 colorA (vec2 p) {
    vec3 colorA = vec3(0.4, 0.7, 0.9); // light blue
    vec3 colorB = vec3(0.9, 0.5, 0.1); // orange
    vec3 colorC = vec3(0.4);
    
    vec3 color = step(0.5, 1 - p.x) * colorA + step(0.5, p.x) * colorB;

    float block3 = plotA(p); // get color 3 block area

    return (1 - block3) * color + block3 * colorC;
}


vec3 colorB (vec2 p) {
    vec3 colorA = vec3(0.2, 0.15, 0.3); // dark purpl
    vec3 colorB = vec3(0.6, 0.4, 0.5); // purple
    vec3 colorC = vec3(0.55, 0.35, 0.45); // mid purp
    
    vec3 color = step(0.5, 1 - p.x) * colorA + step(0.5, p.x) * colorB;

    float block3 = plotA(p); // get color 3 block area

    return (1 - block3) * color + block3 * colorC;
}

vec3 colorC (vec2 p) {
    vec3 colorA = vec3(0.4, 0.7, 0.9); // light blue
    vec3 colorB = vec3(0.9, 0.5, 0.1); // orange
    vec3 colorC = vec3(0.4);
    vec3 colorD = vec3(0.85, 0.8, 0.4);
    vec3 colorE = vec3(0.2, 0.2, 0.4);
    
    vec3 color = step(0.5, 1 - p.x) * colorA + step(0.5, p.x) * colorB;
    color = step(0.5, 1 - p.y) * colorA + step(0.5, p.y) * colorB;
    float block3 = plotC1(p); // get color 3 block area
    float block4 = plotC2(p); // get color 3 block area
    float block5 = plotC3(p); // get color 3 block area
    color = (1 - block3) * color + block3 * colorC;
    color = (1 - block4) * color + block4 * colorD;
    color = (1 - block5) * color + block5 * colorE;
    return color;
}

vec3 colorD (vec2 p) {
    
    vec3 colorC = vec3(0.4);
    vec3 color = vec3(p.y);
    float block3 = plotA(p); // get color 3 block area
    color = (1 - block3) * color + block3 * colorC;
    return color;
}

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec3 color = vec3(0.0);

    //color = colorA(st);
    //color = colorB(st);
    //color = colorC(st);
    color = colorD(st);

    gl_FragColor = vec4(color,1.0);
}

