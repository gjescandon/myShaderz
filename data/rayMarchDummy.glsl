// Author: Inigo Quiles
// Title: Expo
#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER
#define PI 3.14159265359
#define TWO_PI 6.28318530718 
#define MAX_STEPS 100
#define SURFACE_DIST 0.01
#define MAX_DIST 100.

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

float trishape(vec2 st, int N) {
  st = st *2.-1.;
  // N: Number of sides of your shape

  // Angle and radius from the current pixel
  float a = atan(st.x,st.y)+PI + sin(0.3*u_time);
  float r = TWO_PI/float(N);

  // Shaping function that modulate the distance
  float d = cos(floor(.5+a/r)*r-a)*length(st);
//  float d = sin(floor(.5+a/r)*r-a)*0.6*length(st);

  return 1.-smoothstep(.4,.41,d);
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

float getDistance(vec3 p) {

    // ground plane
    //float dP = dCamera.y - dPlane.y; // height of camera
    // input p = dP height of camera

    // sphere
    //float dS = length(pSphere-pCamera) - sphereRadius;
    vec4 sphere = vec4(0, 2., 6., 1); // sphere xyz + radius w
    float dS = length(p-sphere.xyz) - sphere.w;
    float dP = p.y + 2.*random2(vec2(p.y,4.));

    // do not step into objects!
    //dMarch = min(dPlane, dSphere);
    float dM = min(dP, dS);
    return dM;
}

float rayMarch(vec3 ro, vec3 rd) {
    float d0 = 0.;
    for (int i = 0; i<MAX_STEPS; i++) {
        vec3 p = ro + d0*rd;
        float dS = getDistance(p);
        d0 += dS;
        // shaders have no break ??
        // if (dS<SURFACE_DIST || d0>MAX_DIST) break
    }
    return d0;
}

vec3 getNormal(vec3 p) {
    float e = 0.01;
    float d = getDistance(p);
    vec3 d2 = vec3(
        getDistance(p+vec3(e,0,0)),
        getDistance(p+vec3(0,e,0)),
        getDistance(p+vec3(0,0,e)));
    return normalize(d2-d);
}

float getLighting(vec3 p) {
    // simple lighting modulate
    // angle 90 : 1.0 illumination
    // angle 180: 0.0

    // light vector vs normal vector >> dot product!
    // light = dot(lightVector, normalVector)
    // lightVector = normalize(lightPos-surfacePos);
    // normalVector = getNormal

    vec3 lightP = vec3(0,5,3);
    lightP.xy += 2.*vec2(sin(u_time),cos(u_time));
    vec3 l = normalize(lightP-p);
    vec3 n = getNormal(p);
    float dif = clamp(dot(n,l),0,1);

    // apply shadows
    float sd = rayMarch(p+n*SURFACE_DIST,l); // adding  n*SURFACE_DIST to avoid surface artifacts
    if (sd < length(lightP-p)) {
        dif *= 0.1;
    }
    return dif;

}
void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec2 p = 2.*st - 1.;

    vec3 ro = vec3(0.,1.,0.); // camera position
    vec3 rd = normalize(vec3(p.x,p.y,1.));     // ray vector 

    // get the intersections
    // how far away is the camera from the scene surface?

    vec3 c = vec3(1.);

    float d = rayMarch(ro, rd);
    vec3 pl = ro + rd*d;
    float dif = getLighting(pl);
    c = vec3(d);
    c = getNormal(pl);
    c = vec3(dif);
    gl_FragColor = vec4(c,1.0);

}