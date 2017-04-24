#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
uniform sampler2D mask;
varying vec2 texCoord;
varying vec2 texCoordMask;

void kore() {
	vec4 texcolor = texture2D(tex, texCoord) ;
	vec4 maskColor=texture2D(mask, texCoordMask) ;
	texcolor.xyz*=(1.-maskColor.w);
	
	gl_FragColor = vec4(texcolor.x,texcolor.y,texcolor.z,(1.-maskColor.a)*texcolor.a);
}
