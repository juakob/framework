#version 450

in vec2 vertexPosition;
in vec4 texPosition;

uniform mat4 projectionMatrix;
out vec4 texCoord;


void kore() {
	gl_Position =  projectionMatrix*vec4(vertexPosition.xy,0.0, 1.0) ;
	texCoord = texPosition;

}
