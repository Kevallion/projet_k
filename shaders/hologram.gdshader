shader_type canvas_item;

uniform vec4 color : source_color;

uniform vec3 glow_color : source_color = vec3(0.2, 0.0, 1.0);
uniform float scan_position : hint_range(0.5, 1.0);
uniform float scan_width = 0.05;
uniform float glow_strength = 10;

void fragment() {
	
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR = mix(texture_color, color, texture_color + (sin(TIME)*0.4) + vec4(0.5));
	
	vec4 scanColor = texture(TEXTURE, UV);
	float distance = abs(SCREEN_UV.y - scan_position + sin(-TIME)*0.15);
	float glow = smoothstep(scan_width*0.1, 0.0, distance);
	
	scanColor.rgb += glow * glow_strength * glow_color;
	
	COLOR *= scanColor;
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
