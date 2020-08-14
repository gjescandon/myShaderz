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

float circle(vec2 _st, float _radius) {
    vec2 dist = _st-vec2(0.5);
	return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(dist,dist)*4.0);
}

float circleBlack(vec2 _st, float _radius) {
    vec2 dist = _st-vec2(0.5);
	return smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(dist,dist)*4.0);
}

void main(){
	vec2 st = gl_FragCoord.xy/u_resolution;
    //st = fract(4.0 * abs(sin(u_time)) * st);
    //st.x = 0.01 * sin(u_time);

    float pct = 0.0;

    // a. The DISTANCE from the pixel to the center
    pct = distance(st,vec2(0.5));

    // b. The LENGTH of the vector
    //    from the pixel to the center
     vec2 toCenter = vec2(0.5)-st;
     //pct = length(toCenter);

    // c. The SQUARE ROOT of the vector
    //    from the pixel to the center
    // vec2 tC = vec2(0.5)-st;
    // pct = sqrt(tC.x*tC.x+tC.y*tC.y);


    // d. step circle
    float dd = smoothstep(0.25, 0.255, length(toCenter));
    dd = circleBlack(st + vec2(0.05*sin(u_time), 0.05*cos(u_time)), 0.25);

    float beater = 0.03 * sin(u_time);
    float dd2 = smoothstep(0.65 + beater, 0.7 + beater, 1.-length(toCenter));
    pct = dd*dd2;
    vec3 color = vec3(pct);

    pct = distance(st,vec2(0.4)) + distance(st,vec2(0.6));
    pct = distance(st,vec2(0.4)) * distance(st,vec2(0.6));
    //pct = min(distance(st,vec2(0.4)),distance(st,vec2(0.6)));
    //pct = max(distance(st,vec2(0.4)),distance(st,vec2(0.6)));
    //pct = pow(distance(st,vec2(0.4)),distance(st,vec2(0.6)));

    vec3 colorB = vec3(0.,0.,0.9);
    color = (1-pct)*color + pct * colorB;
	gl_FragColor = vec4( color, 1.0 );
}