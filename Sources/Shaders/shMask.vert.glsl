#version 450

in vec2 vertexPosition;
in vec2 texPosition;

uniform mat4 projectionMatrix;
out vec2 texCoord;
out vec2 texCoordMask;

void kore() {
	vec4 pos =  projectionMatrix*vec4(vertexPosition.xy,0.0, 1.0) ;
	texCoord = texPosition;

	vec2 v_texCoordMask= texPosition; //vec2((1.0 + pos.x)*0.5,(1.0 + pos.y)*-0.5);
	texCoordMask=v_texCoordMask;
	gl_Position=pos;
	
	
}
