shader_type canvas_item;

uniform vec2 half_size_px = vec2(16.0, 16.0); // set to texture_size/2 (or region size/2)
uniform float inner_radius : hint_range(0.0, 1.0) = 0.25;
uniform float outer_radius : hint_range(0.0, 1.0) = 0.50;

varying vec2 local_pos;

void vertex() {
    local_pos = VERTEX; // local quad position in pixels
}

void fragment() {
    vec4 col = texture(TEXTURE, UV);

    // normalize so the circle is based on the smaller axis (perfect circle)
    float min_half = min(half_size_px.x, half_size_px.y);
    vec2 p = local_pos / min_half; // centered at (0,0)

    float d = length(p); // 0 at center, ~1 at edge of smaller axis

    float a = 1.0 - smoothstep(inner_radius, outer_radius, d);
    col.a *= a;
	col *= COLOR;
    COLOR = col;
}
