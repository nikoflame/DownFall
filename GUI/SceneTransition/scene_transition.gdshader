shader_type canvas_item;

uniform vec2 center_uv = vec2(0.5);
uniform float radius_px = 150.0;
uniform float softness_px = 0.0;

void fragment() {
    vec2 viewport_size = vec2(1.0) / SCREEN_PIXEL_SIZE;
    vec2 center_px = center_uv * viewport_size;

    float dist_px = distance(FRAGCOORD.xy, center_px);

    // Outside = black (1), inside = transparent (0)
    float alpha = smoothstep(radius_px - softness_px, radius_px, dist_px);

    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
