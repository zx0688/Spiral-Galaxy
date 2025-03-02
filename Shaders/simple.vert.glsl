#version 450

in vec3 pos;
in vec2 uv;

out vec2 vUV;
in mat4 MVP;

void main() {
	gl_Position = MVP * vec4(pos, 1.0);
	vUV = uv;
}