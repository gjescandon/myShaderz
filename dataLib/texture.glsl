// Author: @patriciogv - 2015
// Title: Stippling

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

//uniform sampler2D u_tex0;
uniform vec2 u_tex0Resolution;

uniform vec2 u_resolution;
//uniform vec2 u_mouse;
uniform float u_time;

uniform sampler2D texCol;
uniform sampler2D texLUT;

void main( void )
{
    vec4 uv = texture2D( texLUT, gl_TexCoord[0].xy );
    vec4 co = texture2D( texCol, uv.xy + vec2(time) );
    gl_FragColor = co;
}
