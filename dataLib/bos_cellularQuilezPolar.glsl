#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// http://www.iquilezles.org/www/articles/voronoilines/voronoilines.htm

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

vec3 voronoi( in vec2 x ) {
    vec2 n = floor(x);
    vec2 f = fract(x);

    // first pass: regular voronoi
    vec2 mg, mr;
    float md = 8.0;
    for (int j= -1; j <= 1; j++) {
        for (int i= -1; i <= 1; i++) {
            vec2 g = vec2(float(i),float(j));
            vec2 o = random2( n + g );
            o = 0.5 + 0.5*sin( u_time + 6.2831*o );

            vec2 r = g + o - f;
            float d = dot(r,r);

            if( d<md ) {
                md = d;
                mr = r;
                mg = g;
            }
        }
    }

    // second pass: distance to borders
    md = 8.0;
    for (int j= -2; j <= 2; j++) {
        for (int i= -2; i <= 2; i++) {
            vec2 g = mg + vec2(float(i),float(j));
            vec2 o = random2( n + g );
            o = 0.5 + 0.5*sin( u_time + 6.2831*o );

            vec2 r = g + o - f;

            if ( dot(mr-r,mr-r)>0.00001 ) {
                md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            }
        }
    }
    return vec3(md, mr);
}

float plotCircle(vec2 p, float rad) {

    float y = 0.;
    if (abs(p.x) <= rad) {
      y = sqrt(rad*rad-p.x*p.x);
    }
    float x = 0.;
    if (abs(p.y) <= rad) {
      x = sqrt(rad*rad-p.y*p.y);
    }
    float d = 0.;
    if (y > 0. && x > 0.) {
    d =     smoothstep( y-0.02, y, abs(p.y)) -
          smoothstep( y, y+0.02, abs(p.y)) +
        smoothstep( x-0.02, x, abs(p.x)) -
          smoothstep( x, x+0.02, abs(p.x))          
          ;
    }
    
    return d;

}
void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    vec3 color = vec3(0.);

    // Scale
    float N = 4.;
    st = N * (2.*st - 1);



    //vec3 c = voronoi(st);
    float rad = 0.5*N;
    float pct = plotCircle(st,rad);
    //color = vec3(abs(pct));
    pct = plotCircle(st,0.5 * rad);
    //color += vec3(abs(pct));


    color = vec3(smoothstep(0.99,1.01,rad*rad/(st.x*st.x+st.y*st.y))-smoothstep(0.99,1.01,0.98*rad*rad/(st.x*st.x+st.y*st.y)));
    gl_FragColor = vec4(color,1.0);
}

