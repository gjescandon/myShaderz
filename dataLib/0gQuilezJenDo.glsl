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
uniform float[100] iRarr;
//uniform int jdoCnt;

  
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

  float c1 = 1 + floor(10*iRandom1); // sin rate
  float c2 = 1 + floor(10*iRandom1);
  float c3 = 1 + floor(10*iRandom1);
  

  float d1 = 0.; // offset
  float d2 = 0.3;
  float d3 = 0.6;
  float factor = 1.0;

  float tnom = t0-floor(t0);   // between 0.0 and 1.0

  a1 = fract(10*iRandom1);
  a2 = fract(10*iRandom2);
  a3 = fract(10*iRandom3);

  b1 = fract(100*iRandom1);
  b2 = fract(100*iRandom2);
  b3 = fract(100*iRandom3);

  d1 = fract(1000*iRandom1);
  d2 = fract(1000*iRandom2);
  d3 = fract(1000*iRandom3);

  
  float b1f = b1 * cos(TWO_PI*(c1*tnom+d1));
  float red1 = clamp(factor * (a1 + b1f),0.,1.);
  float b2f = b2 * cos(TWO_PI*(c2*tnom+d2));
  float grn2 = clamp(factor * (a2 + b2f),0.,1.);
  float b3f = + b3 * cos(TWO_PI*(c3*tnom+d3));
  float blu3 = clamp(factor * (a3 + b3f),0.,1.);
  vec3 c = vec3(red1,grn2,blu3);
  return c;   
 }



float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

float sdEllipse( in vec2 p, in vec2 ab )
{
    p = abs(p); if( p.x > p.y ) {p=p.yx;ab=ab.yx;}
    float l = ab.y*ab.y - ab.x*ab.x;
    float m = ab.x*p.x/l;      float m2 = m*m; 
    float n = ab.y*p.y/l;      float n2 = n*n; 
    float c = (m2+n2-1.0)/3.0; float c3 = c*c*c;
    float q = c3 + m2*n2*2.0;
    float d = c3 + m2*n2;
    float g = m + m*n2;
    float co;
    if( d<0.0 )
    {
        float h = acos(q/c3)/3.0;
        float s = cos(h);
        float t = sin(h)*sqrt(3.0);
        float rx = sqrt( -c*(s + t + 2.0) + m2 );
        float ry = sqrt( -c*(s - t + 2.0) + m2 );
        co = (ry+sign(l)*rx+abs(g)/(rx*ry)- m)/2.0;
    }
    else
    {
        float h = 2.0*m*n*sqrt( d );
        float s = sign(q+h)*pow(abs(q+h), 1.0/3.0);
        float u = sign(q-h)*pow(abs(q-h), 1.0/3.0);
        float rx = -s - u - c*4.0 + 2.0*m2;
        float ry = (s - u)*sqrt(3.0);
        float rm = sqrt( rx*rx + ry*ry );
        co = (ry/sqrt(rm-rx)+2.0*g/rm-m)/2.0;
    }
    vec2 r = ab * vec2(co, sqrt(1.0-co*co));
    return length(r-p) * sign(p.y-r.y);
}


float sdEquilateralTriangle( in vec2 p )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - 1.0;
    p.y = p.y + 1.0/k;
    if( p.x+k*p.y>0.0 ) p = vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0, 0.0 );
    return -length(p)*sign(p.y);
}


float sdTriangle( in vec2 p, in vec2 p0, in vec2 p1, in vec2 p2 )
{
    vec2 e0 = p1-p0, e1 = p2-p1, e2 = p0-p2;
    vec2 v0 = p -p0, v1 = p -p1, v2 = p -p2;
    vec2 pq0 = v0 - e0*clamp( dot(v0,e0)/dot(e0,e0), 0.0, 1.0 );
    vec2 pq1 = v1 - e1*clamp( dot(v1,e1)/dot(e1,e1), 0.0, 1.0 );
    vec2 pq2 = v2 - e2*clamp( dot(v2,e2)/dot(e2,e2), 0.0, 1.0 );
    float s = sign( e0.x*e2.y - e0.y*e2.x );
    vec2 d = min(min(vec2(dot(pq0,pq0), s*(v0.x*e0.y-v0.y*e0.x)),
                     vec2(dot(pq1,pq1), s*(v1.x*e1.y-v1.y*e1.x))),
                     vec2(dot(pq2,pq2), s*(v2.x*e2.y-v2.y*e2.x)));
    return -sqrt(d.x)*sign(d.y);
}

void main( void )
{
    
    vec2 p = vec2(1.);
    //p = ((2.0+sin(0.03*iTime))*gl_FragCoord.xy-iResolution.xy)/iResolution.y;
    //p = gl_FragCoord.xy/iResolution.xy - vec2(0.5);

  p = (2.0*gl_FragCoord.xy-0.9*iResolution.xy)/iResolution.y;
	//p = (2.0*gl_FragCoord.xy)/iResolution.y;
	//p = gl_FragCoord.xy)/iResolution;
	//p *= 1.5;
  
  vec3 colArr[13];
  float  jdoArr[13];
  for (int i = 0; i < colArr.length(); i++) {
    colArr[i] = vec3(0.);
    jdoArr[i] = 1.;
  }    

  int jdoCnt = 0;
  jdoArr[0] = 0.8;
  vec3 col = vec3(0.);
  float dt;
  float dtx = 0.;
  float a = 0.;
  float b = 0.;
  float c = 0.;
  float d = 0.;
  float e = 0.;
  float f = 0.;

  for (int i = 0 ; i < iRarr.length(); i++) {
    float ii = iRarr[i];
    if (ii == 1.) { //square
       a = iRarr[i+1]/iResolution.x;
       b = iRarr[i+2]/iResolution.y;
       c = iRarr[i+3]/iResolution.x;
       d = iRarr[i+4]/iResolution.y;
       //a = iRarr[i+1];
       //b = iRarr[i+2];
       //c = iRarr[i+3];
       //d = iRarr[i+4];
       dt = sdBox( p - vec2(a,b), vec2(c,d));
      jdoArr[jdoCnt] = dt;
  
      jdoCnt++;
    }
    
    if (iRarr[i] == 2.) { //triangle
       a = iRarr[i+1]/iResolution.x;
       b = iRarr[i+2]/iResolution.y;
       c = iRarr[i+3]/iResolution.x;
       d = iRarr[i+4]/iResolution.y;
       e = iRarr[i+5]/iResolution.x;
       f = iRarr[i+6]/iResolution.y;
  
      float dt = sdTriangle(p, vec2(a,b), vec2(c,d), vec2(e,f));
      jdoArr[jdoCnt] = dt;
      dtx = dt;
  
      jdoCnt++;
    }
    if (iRarr[i] == 3.) { //circle
       a = iRarr[i+1]/iResolution.x;
       b = iRarr[i+2]/iResolution.y;
       c = iRarr[i+3]/iResolution.y;
      float dt = sdCircle( p , c );
      dt = sdCircle( p - vec2(-0.5*a,b), c);
      jdoArr[jdoCnt] = dt;
      //dtx = dt;
  
      jdoCnt++;
    }

  }


  for (int i = 0 ; i < jdoArr.length(); i++) {
    colArr[i] = vec3(1.0) - sign(jdoArr[i])*vec3(1.);
	  colArr[i] *= 1.0 - abs(sin(0.01*iTime + i * PI / jdoArr.length()))*exp(-2.0*abs(jdoArr[i])); // interior color
	  //colArr[i] *= 0.8 + 0.2*cos(120.0*jdoArr[i]);  // gradient lines
    colArr[i] = mix( colArr[i], vec3(1.0), 1.0-smoothstep(0.0,0.02,abs(jdoArr[i])) );  // shape boundary
    }

  for (int i = 0 ; i < colArr.length(); i++) {
  //for (int i = 0 ; i < 5; i++) {
    for (int j = i; j >0; j--) {
      col -= colArr[i]*colArr[j] * getColor(iRandom1 + (i-j) * 0.6);
    }
    col += colArr[i] * getColor(iRandom1 + i * 0.6 + 0.01*iTime);
  }
   

    //col = vec3(1.0) - sign(dtx)*vec3(1.);
	  //col *= 1.0 - exp(-2.0*abs(dtx)); // interior color
	  //col *= 0.8 + 0.2*cos(120.0*dtx);  // gradient lines
    //col = mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.02,abs(dtx)) );  // shape boundary
 
  //col += colArr[1]*getColor(0.01*iTime + 1.*0.2);
  //col = vec3(1.0) *p.x*getColor((dt));

  /* **** MAKE INTERSECTIONS SEE-THRU BY *EXCLUDING* FROM LINE BELOW *** */
  //col -= 0.5*colA*colB + 0.5*colA*colC + 0.5 *colB*colC; // darken intersections
  

  /* ALT INTERSECTION COLOR */
  //col += colA*colB*getColor(0.01*iTime + 0.6) + colA*colC*getColor(0.01*iTime + 0.8);// + colB*colC*getColor(0.01*iTime + 0.1);
  //fragColor = vec4(col,1.0);  // shaderToy
    
	vec2 v1 = cos( iTime + vec2(0.0,2.00) + 0.0 );
	vec2 v2 = cos( iTime + vec2(0.0,1.50) + 1.5 );
	vec2 v3 = cos( iTime + vec2(0.0,3.00) + 4.0 );

	float dd = sdTriangle( p, v1, v2, v3 );
  dd = sdBox(p - v1, v3);
	
  dd = sdCircle(p, 0.8);
  //col = vec3(1.0) - sign(dd)*vec3(1.);
  //col *= 1.0 - exp(-3.0*abs(dd));
	//col *= 0.8 + 0.2*cos(120.0*dd);
	//col += mix( col, vec3(1.0), 1.0-smoothstep(0.0,0.02,abs(dd)) );
    gl_FragColor = vec4(col, 1.0);

}
