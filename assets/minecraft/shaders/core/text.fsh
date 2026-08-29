#version 330

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#moj_import <minecraft:fog.glsl>
#endif

#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
in float sphericalVertexDistance;
in float cylindricalVertexDistance;
#endif

in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

const float MIN = 0.249;
const float MAX = 0.251;

void main() {
#ifdef IS_GRAYSCALE
    vec4 texColor = texture(Sampler0, texCoord0).rrrr;
#else
    vec4 texColor = texture(Sampler0, texCoord0);
#endif

// GUI text color hack fix, the alternative is language files for *every* language.
	// This specifically targets the specific color of text in UIs.
	vec4 correctedVertexColor;
	if (vertexColor.r >= MIN && vertexColor.r <= MAX && vertexColor.r >= MIN && vertexColor.r <= MAX && vertexColor.r >= MIN && vertexColor.r <= MAX) {
		correctedVertexColor = vec4(1);
	} else {
		correctedVertexColor = vertexColor;
	}

#ifdef IS_SEE_THROUGH
    vec4 color = texColor * correctedVertexColor;
#else
    vec4 color = texColor * correctedVertexColor * ColorModulator;
#endif
    if (color.a < 0.1) {
        discard;
    }

#ifdef IS_SEE_THROUGH
    fragColor = color * ColorModulator;
#elif defined(IS_GUI)
    fragColor = color;
#else
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
#endif
}
