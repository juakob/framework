precision mediump float;
 
uniform sampler2D tex;
 
varying vec2 v_texCoord;
varying vec2 v_blurCoord0;
varying vec2 v_blurCoord1;
varying vec2 v_blurCoord2;
varying vec2 v_blurCoord3;
varying vec2 v_blurCoord4;
varying vec2 v_blurCoord5;

 
void main()
{
	
    vec4 texcolor = texture2D(tex, v_texCoord  )*0.383103;
	texcolor += texture2D(tex,v_blurCoord0)*0.00598;
    texcolor += texture2D(tex,v_blurCoord1)*0.060626;
    texcolor += texture2D(tex, v_blurCoord2)*0.241843;
    texcolor += texture2D(tex, v_blurCoord3)*0.241843;
	 texcolor += texture2D(tex, v_blurCoord4)* 0.060626;
	 texcolor += texture2D(tex, v_blurCoord5)* 0.00598;
	gl_FragColor=texcolor;
   
}
