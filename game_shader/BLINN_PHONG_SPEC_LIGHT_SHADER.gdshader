shader_type spatial;

uniform vec3 light_position = vec3(0.0, 1.0, 2.0);
uniform vec3 light_color = vec3(1.0, 1.0, 1.0);
//uniform vec3 light_color = vec3(0, 0, 0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;
uniform float near_plane = 0.1;
uniform float far_plane = 100.0;
// Define epsilon as a constant if it doesn't need to change
const float epsilon = 0.01;

//Linear Depth Calculation:
//The linearize_depth function converts
//the non-linear depth values stored in the depth buffer
//to linear depth values.
//This is useful for more intuitive
//depth-based rendering where depth values increase
//linearly with distance from the camera.
float linearize_depth(float depth) {
    // This function linearizes the depth value from the depth buffer
    float z = depth * 2.0 - 1.0; // Back to NDC
    return (2.0 * near_plane * far_plane) / (far_plane + near_plane - z * (far_plane - near_plane));
}


//void vertex() {
    //POSITION = vec4(VERTEX.xy, VERTEX.z, 1.0);
//}

//void vertex() {
    //POSITION = vec4(VERTEX.xy, VERTEX.z, 0.8);
//}


void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
    float linear_depth = linearize_depth(depth);

	// Standard scene lighting calculation for non-sky elements
        vec3 screen_normal = screen_color.rgb * 2.0 - 1.0; // Convert from [0, 1] to [-1, 1]
		vec3 view_dir = normalize(-VERTEX); // Assuming the camera is at the origin
        vec3 light_dir = normalize(light_position - VERTEX);

        // Diffuse lighting
        float diff = max(dot(screen_normal, light_dir), 0.8);
        vec3 diffuse = diff * light_color;

        // Specular lighting using Blinn-Phong model
        vec3 halfway_dir = normalize(light_dir + view_dir);
        //float spec = pow(max(dot(screen_normal, halfway_dir), 0.0), 32.0);
		float spec = pow(max(dot(screen_normal, halfway_dir), 1.0), 0.0);
        vec3 specular = spec * light_color;

        // Combine results for non-sky elements
        vec3 result = (diffuse + specular) * screen_color.rgb;
        ALBEDO = result;
}

