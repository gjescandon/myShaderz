#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define PI_HALF 1.5707963268
#define PI_QRTR 0.78539816339

#define TWO_PI 6.28318530718 

uniform vec2 iResolution;
//uniform vec2 u_mouse;
uniform float iTime;

uniform float iRandom1;
uniform float iRandom2;
uniform float iRandom3;
uniform sampler2D texture01;

//uniform sampler2D texture;

float random (vec2 st) {
    float x2 = 47.5453123 + 10.*sin(0.01*iTime)+ 10.*cos(0.01*iTime);
    return fract(sin(dot(st.xy,
                         vec2(159.9898,78.233)))*
        x2);
}

float random2 (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float rand(float x) {
    return fract(sin(x) * 100.);
}

float noize3(float x) {
  float i = floor(x);  // integer
  float f = fract(x);  // fraction
  float u = f * f * (3.0 - 2.0 * f );
  float y = rand(i); //rand() is described in the previous chapter
  float randMix = 1.;
  y = mix(rand(i), rand(i + randMix), smoothstep(0.,1.,u));
  return fract(y);
}


float hash(vec2 p)  // replace this by something better
{
    p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
    return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
}

float noiseValue( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );
	
	vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( hash( i + vec2(0.0,0.0) ), 
                     hash( i + vec2(1.0,0.0) ), u.x),
                mix( hash( i + vec2(0.0,1.0) ), 
                     hash( i + vec2(1.0,1.0) ), u.x), u.y);
}


//https://www.iquilezles.org/www/articles/palettes/palettes.htm  

  
 
 float getColor1D(float t0) {
   // **** RGB in here **** 
  float a1 = 0.2; // 

  float b1 = 0.2; //oscilators amplitude

  float c1 = 1.5 * (1 - 0.8* cos(0.03*iTime)); //input amplitude

  float d1 = 0.; // offset

  float factor = 1.0;

  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  b1 = iRandom1;
  //c1 = iRandom2;
  d1 = iRandom3;

  float h1 = factor * (a1 + b1 * cos(TWO_PI*(c1*tnom+d1)));
  return h1; //fract(h1);   
 }

  vec3 getColor(float t0) {
   // **** RGB in here **** 
  float a1 = 0.6; // red
  float a2 = 0.5;  // green
  float a3 = 0.7;  // blue
  
  float b1 = 0.4; //oscilators amplitude
  float b2 = 0.2;
  float b3 = 0.5;

  float c1 = 1.0; //input amplitude
  float c2 = 1.0;
  float c3 = 1.0;

  float d1 = 0.; // offset
  float d2 = 0.3;
  float d3 = 0.6;

  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  a1 = iRandom1;
  a2 = iRandom2;
  a3 = iRandom3;

  d1 = iRandom1;
  d2 = iRandom2;
  d3 = iRandom3;

  b1 = iRandom3;
  b2 = iRandom1;
  b3 = iRandom2;

  c1 *= floor(10*iRandom3);
  c2 *= floor(10*iRandom1);
  c3 *= floor(10*iRandom2);

  
  float b1f = b1 * cos(TWO_PI*(c1*tnom+d1));
  float red1 = clamp((a1 + b1f), 0., 1.);
  float b2f = b2 * cos(TWO_PI*(c2*tnom+d2));
  float grn2 = clamp((a2 + b2f), 0., 1.);
  float b3f = + b3 * cos(TWO_PI*(c3*tnom+d3));
  float blu3 = clamp((a3 + b3f), 0., 1.);
  vec3 c = vec3(red1,grn2,blu3);
  return c;   
 }



// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// Instead of using a pont, circle, line or any mathematical shape for traping the orbit
// of fc(z), one can use any arbitrary shape. For example, a NyanCat :)
//
// I invented this technique more than 10 years ago (can have a look to those experiments 
// here http://www.iquilezles.org/www/articles/ftrapsbitmap/ftrapsbitmap.htm).

vec4 getNyanCatColor( vec2 p, float time )
{
	p = clamp(p,0.0,1.0);
	//p.x = p.x*40.0/256.0;
	p.x = 0.5 + 1.0*(0.5-p.x);
	p.y = 0.5 + 1.0*(0.5-p.y);
	p = clamp(p,0.0,1.0);
	//float fr = floor( mod( 20.0*time, 6.0 ) );
	//p.x += fr*40.0/256.0;
	return texture2D( texture01, p);
}

void main( void)
{
    vec2 p = (2.0*gl_FragCoord.xy-iResolution.xy)/iResolution.y;
    
    float time = max( iTime-5.5, 0.0 );
    
    // zoom	
    float zz = 20.; // 20.;
    float pzz = 1.75; // 0.75;
	p = vec2(0.5,-0.05)  + p*pzz * pow( .7, zz*(0.5+0.5*cos(0.15*time)) );
	
    vec4 col = vec4(0.0);
    vec3 sa = vec3( 0.2,0.2, 1.0 ); //vec3( 0.2,0.2, 1.0 );
    vec3 sb = vec3( 0.4,-0.2,0.8);//vec3( 0.5,-0.2,0.5);
	vec3 s = mix( sa, sb, 0.5+0.5*sin(0.5*time) );

    // iterate Jc	
	vec2 c = vec2(-0.76, 0.15);
	float f = 0.0;
	vec2 z = p;
	for( int i=0; i<100; i++ )
	{
		if( (dot(z,z)>4.0) || (col.w>0.1) ) break;

        // fc(z) = z² + c		
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
		
		col = getNyanCatColor( s.xy + 1.1*s.z*z, time );
    //col.xyz = getColor(2.0*length(z));
		f += 1.0;
	}
	
	vec3 bg = 0.5*vec3(1.0,0.5,0.5) * sqrt(f/100.0);
	
	col.xyz = mix( bg, col.xyz, col.w );
    
    //col *= step( 2.0, iTime );
    //col += texture( iChannel1, vec2(0.01,0.2) ).x * (1.0-step( 5.5, iTime ));
    //col += texture2D(texture01, vec2(0.01,0.2) ).x * (1.0-step( 5.5, iTime ));
	gl_FragColor = vec4( col.xyz,1.0);
}
