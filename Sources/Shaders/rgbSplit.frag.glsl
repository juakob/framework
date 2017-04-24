#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
varying vec2 texCoord;
uniform float time;

void kore() {
	vec2 value = vec2(1.5,1.5);

	vec4 c1 = texture2D( tex, texCoord - value/500.0 );
	vec4 c2 = texture2D( tex, texCoord );
	vec4 c3 = texture2D( tex, texCoord + value /500.0);
	
	vec4 col = vec4( c1.r, c2.g, c3.b, c1.a + c2.a + c3.b );
	float scanLines =cos( time+texCoord.y * 300.5);
	
	float saturation = scanLines*scanLines;
	col.xyz = col.xyz * vec3(1.0 + 0.2 * saturation);
	
	gl_FragColor = col;
}
