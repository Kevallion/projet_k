shader_type canvas_item;

uniform sampler2D noise_texture;

void fragment() {
	COLOR = vec4(UV, 0.0, 1.0);
}

