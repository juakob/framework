#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
in vec4 texCoord;
out vec4 FragColor;

void kore() {
	vec4 texcolor = texture(tex, texCoord.xy) ;
	vec4 maskColor= texture(tex, texCoord.zw);
	texcolor*=maskColor.w;
	
	FragColor = texcolor;
}
