#version 450

in vec2 vUV;

uniform sampler2D utexture;

out vec4 fragColor;

void main() {

 	vec4 color = texture(utexture, vUV);
	if (color.a < 0.2) {
        discard;
    }

	fragColor = color;
}
