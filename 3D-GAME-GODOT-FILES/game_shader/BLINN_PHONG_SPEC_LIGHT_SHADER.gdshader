shader_type spatial;

// Uniforms for light properties
uniform vec3 light_position = vec3(0.0, 1.0, 2.0); // Position of the light in world space
uniform vec3 light_color = vec3(1.0, 1.0, 1.0);   // Color of the light, currently set to white

// Uniforms for screen texture and depth information
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap; // Screen texture for color information
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture; // Depth texture for depth information

// Uniforms for depth calculation
uniform float near_plane = 0.1;  // Near clipping plane of the camera
uniform float far_plane = 100.0; // Far clipping plane of the camera

// Small constant to avoid division by zero or other numerical instabilities
const float epsilon = 0.01;

// Function to convert depth from non-linear to linear space
float linearize_depth(float depth) {
    float z = depth * 2.0 - 1.0; // Converts depth from [0, 1] to NDC [-1, 1]
    return (2.0 * near_plane * far_plane) / (far_plane + near_plane - z * (far_plane - near_plane));
}

void fragment() {
    // Sample the screen color at the current fragment's UV coordinate
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Sample the depth at the current fragment's UV coordinate
    float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;

    // Convert depth to linear space for correct lighting calculations
    float linear_depth = linearize_depth(depth);

    // Convert screen color to a normal vector in view space (assuming screen color encodes normal)
    vec3 screen_normal = screen_color.rgb * 2.0 - 1.0;

    // Calculate view direction from the current vertex to the camera
    vec3 view_dir = normalize(-VERTEX);

    // Calculate light direction from vertex to light position
    vec3 light_dir = normalize(light_position - VERTEX);

    // Compute diffuse lighting; note:
	//'0.8' ensures some ambient light
	// even when facing away from light
    float diff = max(dot(screen_normal, light_dir), 0.8);
    vec3 diffuse = diff * light_color;

    // Calculate the halfway vector for Blinn-Phong specular lighting
    vec3 halfway_dir = normalize(light_dir + view_dir);

    // Compute specular lighting;
	// note:
	// pow() should be less than 1 for correct specular effect
	// Typically, you would use a value like 32.0
	// for shininess or glossiness in the exponent for Blinn-Phong.
    float spec = pow(max(dot(screen_normal, halfway_dir), 0.2), 32.0);
    vec3 specular = spec * light_color;

    // Combine diffuse and specular with the screen color to get the final fragment color
    vec3 result = (diffuse + specular) * screen_color.rgb;
    ALBEDO = result; // Set the albedo (base color) of the material for this fragment
}
