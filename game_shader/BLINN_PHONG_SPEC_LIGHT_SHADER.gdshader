shader_type spatial;

uniform vec3 light_position = vec3(0.0, 1.0, 2.0);
uniform vec3 light_color = vec3(1.0, 1.0, 1.0);
//uniform vec3 light_color = vec3(0, 0, 0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;
uniform float near_plane = 0.1;
uniform float far_plane = 100.0;
const float epsilon = 0.01;

float linearize_depth(float depth) {
    float z = depth * 2.0 - 1.0; // Back to NDC
    return (2.0 * near_plane * far_plane) / (far_plane + near_plane - z * (far_plane - near_plane));
}

void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
    float linear_depth = linearize_depth(depth);

        vec3 screen_normal = screen_color.rgb * 2.0 - 1.0;
		vec3 view_dir = normalize(-VERTEX);
        vec3 light_dir = normalize(light_position - VERTEX);

        float diff = max(dot(screen_normal, light_dir), 0.8);
        vec3 diffuse = diff * light_color;

        vec3 halfway_dir = normalize(light_dir + view_dir);

		float spec = pow(max(dot(screen_normal, halfway_dir), 1.0), 0.0);
        vec3 specular = spec * light_color;

        vec3 result = (diffuse + specular) * screen_color.rgb;
        ALBEDO = result;
}

