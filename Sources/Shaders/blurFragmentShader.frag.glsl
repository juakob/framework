#version 450
precision mediump float;
 
uniform sampler2D tex;
 
in vec2 v_texCoord;
in vec2 v_blurCoord0;
in vec2 v_blurCoord1;
in vec2 v_blurCoord2;
in vec2 v_blurCoord3;
in vec2 v_blurCoord4;
in vec2 v_blurCoord5;
out vec4 color;
 
void main()
{
	
    vec4 texcolor = texture(tex, v_texCoord  )*0.383103;
	texcolor += texture(tex,v_blurCoord0)*0.00598;
    texcolor += texture(tex,v_blurCoord1)*0.060626;
    texcolor += texture(tex, v_blurCoord2)*0.241843;
    texcolor += texture(tex, v_blurCoord3)*0.241843;
	 texcolor += texture(tex, v_blurCoord4)* 0.060626;
	 texcolor += texture(tex, v_blurCoord5)* 0.00598;
	color=texcolor;
   
}
