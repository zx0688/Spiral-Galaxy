#version 450

// Interpolated values from the vertex shaders
in vec2 vUV;

// Values that stay constant for the whole mesh.
uniform sampler2D myTextureSampler;

out vec4 fragColor;

void main() {

 	vec4 color = texture(myTextureSampler, vUV);
	if (color.a < 0.1) {
        discard; // Отбрасываем пиксель, если его альфа-канал слишком мал (почти прозрачный)
    }

	// Output color = color of the texture at the specified UV
	fragColor = color;
}
