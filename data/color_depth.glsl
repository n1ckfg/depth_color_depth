uniform vec3 iResolution;

uniform sampler2D tex0;

float map(float s, float a1, float a2, float b1, float b2) {
    return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}

float depthFilter(float f1, float f2, float cutoff) {
  if (f1 > cutoff && f2 <= cutoff) f1 = f2;
  return f1;
}

vec3 colorToDepth(vec3 c) {
    float r = map(c.x, 0, 1, 0, 0.33333);
    float g = map(c.y, 0, 1, 0.33333, 0.66667);
    float b = map(c.z, 0, 1, 0.66667, 1.0);

    float r2 = depthFilter(((r / 0.66667) * g), r, 0.33333);
    float g2 = depthFilter(1.0 - (r + b), r, 0.33333);
    float b2 = depthFilter(g + b, r, 0.33333);

    float d = r2 + g2 + b2;
    return vec3(d, d, d);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 uv2 = vec2(uv.x, abs(1.0 - uv.y));


	vec4 col = vec4(colorToDepth(texture2D(tex0, uv2).xyz), 1.0);

	fragColor = col;
}

void main() {
	mainImage(gl_FragColor, gl_FragCoord.xy);
}