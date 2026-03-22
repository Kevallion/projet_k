shader_type canvas_item;

uniform sampler2D cloud_texture_1;
uniform sampler2D cloud_texture_2;

uniform vec2 flow_direction = vec2(1.0, 0.0);
uniform float speed = 0.2;

uniform float intensity : hint_range(0.0, 2.0) = 0.5;
uniform float turbulence : hint_range(0.0, 2.0) = 0.2;

uniform vec3 base_color = vec3(0.1, 0.4, 1.0);

float noise(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec2 dir = normalize(flow_direction);
	
	// mouvement principal
	vec2 offset = TIME * dir * speed;
	
	// turbulence (déformation UV)
	vec2 turb = vec2(
		noise(UV * 5.0 + TIME),
		noise(UV * 5.0 - TIME)
	) * turbulence * 0.1;
	
	vec2 uv1 = fract(UV + offset + turb);
	vec2 uv2 = fract(UV + offset * 0.5 - turb);
	
	vec4 layer1 = texture(cloud_texture_1, uv1);
	vec4 layer2 = texture(cloud_texture_2, uv2);
	
	float flow = mix(layer1.r, layer2.r, 0.5);
	
	// intensité du flux
	float alpha = flow * intensity;
	
	vec3 color = mix(base_color, vec3(1.0), flow);
	
	COLOR = vec4(color, alpha * 0.5);
}