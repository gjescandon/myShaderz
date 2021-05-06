#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Some useful functions
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }

//
// Description : GLSL 2D simplex noise function
//      Author : Ian McEwan, Ashima Arts
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License :
//  Copyright (C) 2011 Ashima Arts. All rights reserved.
//  Distributed under the MIT License. See LICENSE file.
//  https://github.com/ashima/webgl-noise
//
float snoise(vec2 v) {

    // Precompute values for skewed triangular grid
    const vec4 C = vec4(0.211324865405187,
                        // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,
                        // 0.5*(sqrt(3.0)-1.0)
                        -0.577350269189626,
                        // -1.0 + 2.0 * C.x
                        0.024390243902439);
                        // 1.0 / 41.0

    // First corner (x0)
    vec2 i  = floor(v + dot(v, C.yy));
    vec2 x0 = v - i + dot(i, C.xx);

    // Other two corners (x1, x2)
    vec2 i1 = vec2(0.0);
    i1 = (x0.x > x0.y)? vec2(1.0, 0.0):vec2(0.0, 1.0);
    vec2 x1 = x0.xy + C.xx - i1;
    vec2 x2 = x0.xy + C.zz;

    // Do some permutations to avoid
    // truncation effects in permutation
    i = mod289(i);
    vec3 p = permute(
            permute( i.y + vec3(0.0, i1.y, 1.0))
                + i.x + vec3(0.0, i1.x, 1.0 ));

    vec3 m = max(0.5 - vec3(
                        dot(x0,x0),
                        dot(x1,x1),
                        dot(x2,x2)
                        ), 0.0);

    m = m*m ;
    m = m*m ;

    // Gradients:
    //  41 pts uniformly over a line, mapped onto a diamond
    //  The ring size 17*17 = 289 is close to a multiple
    //      of 41 (41*7 = 287)

    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    // Approximation of: m *= inversesqrt(a0*a0 + h*h);
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0+h*h);

    // Compute final noise value at P
    vec3 g = vec3(0.0);
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * vec2(x1.x,x2.x) + h.yz * vec2(x1.y,x2.y);
    return 130.0 * dot(m, g);
}

vec2 random2 (vec2 st) {
    float seedX = 16.9898 + snoise(st);
    float seedY = 72.233 + snoise(st);
    float wobbleX = 20.* sin(0.0000002* u_time);
    float wobbleY = 20.* cos(0.0000002* u_time);
    float rx = fract(sin(dot(st.xy,
                         vec2(seedX,seedY)))*
        43758.5453123 * snoise(st));
    float ry = fract(sin(dot(st.xy,
                         vec2(seedX+wobbleX,seedY+wobbleY)))*
        43758.5453123 * snoise(st));
        
    return vec2(rx, ry);
    //vec2 p = st;
    //return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;

    vec3 color = vec3(.0);

    float gridscale = 9.;
    vec2 p = st * gridscale;
    //tile
    vec2 i_st = floor(p);
    vec2 f_st = fract(p);


    float m_dist = 2.*gridscale;  // minimum distance
    vec2 m_point;        // minimum position

    // Iterate through the points positions
    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x),float(y));
            vec2 point = random2(i_st + neighbor);
            // move the point.


            vec2 diff = neighbor + point - f_st;
            float dist = length(diff);
            
            if ( dist < m_dist ) {
                // Keep the closer distance
                m_dist = dist;

                // Kepp the position of the closer point
                m_point = point;
            }
        }
    }


    // Add distance field to closest point center
    
    color += dot(m_point,vec2(.3,.7));

    // tint acording the closest point position
    //color.rg = m_point;

    // Show isolines
    //color -= abs(sin(40.0*m_dist))*0.07;
    //color +=pow(m_dist,1.9);
    
    // Draw point center
    color += 1.-step(.005, m_dist);

    gl_FragColor = vec4(color,1.0);

}


