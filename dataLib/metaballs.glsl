

// The MIT License
// Copyright © 2013 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org



// Using polynomial fallof of degree 5 for bounded metaballs, which produce smooth normals
// unlike the cubic (smoothstep) based fallofs recommended in literature (such as John Hart).

// The quintic polynomial p(x) = 6x5 - 15x4 + 10x3 has zero first and second derivatives in
// its corners. The maxium slope p''(x)=0 happens in the middle x=1/2, and its value is 
// p'(1/2) = 15/8. Therefore the  minimum distance to a metaball (in metaball canonical 
// coordinates) is at least 8/15 = 0.533333 (see line 63).

// This shader uses bounding spheres for each ball so that rays traver much faster when far
// or outside their radius of influence.

/*
#if HW_PERFORMANCE==0
#define AA 1
#else
#define AA 2
#endif
*/

#define AA 2
#define numballs 7
uniform vec2 iResolution;
uniform vec2 iMouse;
uniform float iTime;
uniform float iRandom1;
uniform float iRandom2;
uniform float iRandom3;
uniform sampler2D iTexture01;
// undefine this for numerical normals
#define ANALYTIC_NORMALS

//----------------------------------------------------------------

float hash1( float n )
{
    return fract(sin(n)*43758.5453123);
}

vec2 hash2( float n )
{
    return fract(sin(vec2(n,n+1.0))*vec2(43758.5453123,22578.1459123));
}

vec3 hash3( float n )
{
    return fract(sin(vec3(n,n+1.0,n+2.0))*vec3(43758.5453123,22578.1459123,19642.3490423));
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

//----------------------------------------------------------------

vec4 blobs[numballs];

float sdMetaBalls( vec3 pos )
{
	float m = 0.0;
	float p = 0.0;
	float dmin = 1e20;
		
	float h = 1.0; // track Lipschitz constant
	
	for( int i=0; i<numballs; i++ )
	{
		// bounding sphere for ball
        float db = length( blobs[i].xyz - pos );
        if( db < blobs[i].w )
    	{
    		float x = db/blobs[i].w;
    		p += 1.0 - x*x*x*(x*(x*6.0-15.0)+10.0);
	    	m += 1.0;
    		h = max( h, 0.5333*blobs[i].w );
	    }
	    else // bouncing sphere distance
	    {
    		dmin = min( dmin, db - blobs[i].w );
    	}
	}
    float d = dmin + 0.1;
	
	if( m>0.5 )
	{
		float th = 0.2;
		d = h*(th-p);
	}
	
	return d;
}


vec3 norMetaBalls( vec3 pos )
{
	vec3 nor = vec3( 0.0, 0.0001, 0.0 );
		
	for( int i=0; i<numballs; i++ )
	{
        float db = length( blobs[i].xyz - pos );
		float x = clamp( db/blobs[i].w, 0.0, 1.0 );
		float p = x*x*(30.0*x*x - 60.0*x + 30.0);
		nor += normalize( pos - blobs[i].xyz ) * p / blobs[i].w;
	}
	
	return normalize( nor );
}


float map( in vec3 p )
{
	return sdMetaBalls( p );
}


const float precis = 0.01;

vec2 intersect( in vec3 ro, in vec3 rd )
{
	float maxd = 10.0;
    float h = precis*2.0;
    float t = 0.0;
    float m = 1.0;
    for( int i=0; i<75; i++ )
    {
        if( h<precis||t>maxd ) continue;//break;
        t += h;
	    h = map( ro+rd*t );
    }

    if( t>maxd ) m=-1.0;
    return vec2( t, m );
}

vec3 calcNormal( in vec3 pos )
{
/*  
#ifdef ANALYTIC_NORMALS	
	return norMetaBalls( pos );
#else	
    vec3 eps = vec3(precis,0.0,0.0);
	return normalize( vec3(
           map(pos+eps.xyy) - map(pos-eps.xyy),
           map(pos+eps.yxy) - map(pos-eps.yxy),
           map(pos+eps.yyx) - map(pos-eps.yyx) ) );
#endif
*/
    vec3 eps = vec3(precis,0.0,0.0);
	return normalize( vec3(
           map(pos+eps.xyy) - map(pos-eps.xyy),
           map(pos+eps.yxy) - map(pos-eps.yxy),
           map(pos+eps.yyx) - map(pos-eps.yyx) ) );
}

float integralSmoothstep( float x, float T )
{
    if( x>T ) return x - T/2.0;
    return x*x*x*(1.0-x*0.5/T)/T/T;
}

void main( void )
{
    //-----------------------------------------------------
    // input
    //-----------------------------------------------------

	vec2 q = gl_FragCoord.xy / iResolution.xy;

	vec2 m = vec2(0.5);
	//if( iMouse.z>0.0 ) m = iMouse.xy/iResolution.xy;

    //-----------------------------------------------------
    // montecarlo (over time, image plane and lens) (5D)
    //-----------------------------------------------------

	vec3 tot = vec3(0.0);
	/*
  #if AA>1
	for( int ax=0; ax<AA; ax++ )
	for( int ay=0; ay<AA; ay++ )
    {
		vec2  poff = vec2( float(ax), float(ay) )/float(AA);
        float toff = 0.0*(float(AA*ay+ax)/float(AA*AA)) * (0.5/24.0); // shutter time of half frame
    #else
	{
		vec2  poff = vec2(0.0);
        float toff = 0.0;
    #endif

    */		
    /// quilez: value noize
    vec3 bckgnd = vec3(0.);
    vec2 p = q;

    float myTime = 15. + iTime;
	  vec2 uv = p*vec2(iResolution.x/iResolution.y,1.0);
    float aspect = iResolution.x/iResolution.y;
	  uv = 2.*uv - vec2(aspect,1.);
    float theta = 0.1*myTime;

    uv.x = integralSmoothstep(abs(0.6*uv.x), 0.3);
    
    // concentric circles
    uv = vec2(length(uv)*cos(theta),length(uv)*sin(theta));
  	float f = 0.0;

    uv = 3.*uv;

    float r = length (uv);
    float a = atan(uv.y * (0.5 + 0.4*cos(0.1*myTime))/abs(uv.x));
    a = atan(uv.y * (0.5 + 0.1*myTime)/abs(uv.x));


		//f = noiseValue( 10.0*vec2(r*a*(1+0.7*cos(u_time*0.4)),a) );
    f = noiseValue( 10.0*vec2(r*a*(myTime*0.04),a) );


	
	bckgnd = vec3(f);
  
for( int ax=0; ax<AA; ax++ )
	for( int ay=0; ay<AA; ay++ )
    {
		vec2  poff = vec2( float(ax), float(ay) )/float(AA);
        float toff = 0.0*(float(AA*ay+ax)/float(AA*AA)) * (0.5/24.0); // shutter time of half frame
  
  
          //-----------------------------------------------------
        // animate scene
        //-----------------------------------------------------
		float time = iTime + toff;

        // move metaballs
		for( int i=0; i<numballs; i++ )
        {
            float h = float(i)/8.0;
            blobs[i].xyz = 2.0*sin( 6.2831*hash3(h*1.17) + hash3(h*13.7)*time );
            blobs[i].w = 1.7 + 0.9*sin(6.28*hash1(h*23.13));
		}

        // move camera		
		float an = 0.5*time - 6.2831*(m.x-0.5); /// m is a mouse function
        an *= 0.1;
		vec3 ro = vec3(5.0*sin(an),2.5*cos(0.4*an),5.0*cos(an));
        vec3 ta = vec3(0.0,0.0,0.0);

		//-----------------------------------------------------
        // camera
        //-----------------------------------------------------
        // image plane		
		vec2 p = (2.0*(gl_FragCoord.xy+poff)-iResolution.xy) / iResolution.y;

        // camera matrix
        vec3 ww = normalize( ta - ro );
        vec3 uu = normalize( cross(ww,vec3(0.0,1.0,0.0) ) );
        vec3 vv = normalize( cross(uu,ww));
        // create view ray
        vec3 rd = normalize( p.x*uu + p.y*vv + 2.0*ww );
        // dof
        
        //#if AA > 4

        vec3 fp = ro + rd * 5.0;
		vec2 le = -1.0 + 2.0*hash2( dot(gl_FragCoord.xy,vec2(131.532,73.713)) + float(AA*ay+ax)*121.41 );
        ro += ( uu*le.x + vv*le.y )*0.1;
        rd = normalize( fp - ro );
        //#endif		

		//-----------------------------------------------------
        // render
        //-----------------------------------------------------

        // background
	    vec3 col = pow( texture2D( iTexture01, rd.xy ).xyz, vec3(2.2) );
		vec3 col1 = texture2D( iTexture01, p ).xyz;
	    // raymarch
        vec2 tmat = intersect(ro,rd);
        if( tmat.y>-0.5 )
        {
            // geometry
            vec3 pos = ro + tmat.x*rd;
            vec3 nor = calcNormal(pos);
    		vec3 ref = reflect( rd, nor );

            // materials
    		vec3 mate = vec3(0.0);
    		float w = 0.01;
    		for( int i=0; i<numballs; i++ )
    		{
    			float h = float(i)/8.0;

                // metaball color
    			vec3 ccc = vec3(1.0);
    			ccc = mix( ccc, vec3(1.0,0.60,0.05), smoothstep(0.65,0.66,sin(30.0*h)));
    			ccc = mix( ccc, vec3(0.3,0.45,0.25), smoothstep(0.65,0.66,sin(15.0*h)));
			
                float x = clamp( length( blobs[i].xyz - pos )/blobs[i].w, 0.0, 1.0 );
                float p = 1.0 - x*x*(3.0-2.0*x);
                mate += p*ccc;
                w += p;
            }
            mate /= w;

            // lighting
    		vec3 lin = vec3(0.0);
			lin += mix( vec3(0.05,0.02,0.0), 1.2*vec3(0.8,0.9,1.0), 0.5 + 0.5*nor.y );
            lin *= 1.0 + 1.5*vec3(0.7,0.5,0.3)*pow( clamp( 1.0 + dot(nor,rd), 0.0, 1.0 ), 2.0 );

    		//lin += 1.5*clamp(0.3+2.0*nor.y,0.0,1.0)*pow(texture2D( iTexture01, ref.xy ).xyz,vec3(2.2))*(0.04+0.96*pow( clamp( 1.0 + dot(nor,rd), 0.0, 1.0 ), 4.0 ));
            //lin += 1.5*clamp(0.3+2.0*nor.y,0.0,1.0)*pow(bckgnd.xyz,vec3(2.2))*(0.04+0.96*pow( clamp( 1.0 + dot(nor,rd), 0.0, 1.0 ), 4.0 ));

	    	// surface-light interacion
    		col = lin * mate;
	    }
        // gamma
	    col = pow( clamp(col,0.0,1.0), vec3(0.45) );
		tot += col;
	}
	tot /= float(AA*AA);
    tot += bckgnd * (1-step(vec3(0.1), tot));
    
    //-----------------------------------------------------
	// postprocessing
    //-----------------------------------------------------

	// vigneting
    tot *= 0.5 + 0.5*pow( 16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y), 0.15 );

    gl_FragColor = vec4( tot, 1.0 );
}

