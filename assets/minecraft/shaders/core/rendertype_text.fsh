#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

const float MIN = 0.248;
const float MAX = 0.25;

void main() {
	// GUI text color hack fix, the alternative is language files for *every* language.
	// This specifically targets the specific color of text in UIs.
	vec4 correctedVertexColor;
	if (vertexColor.r > MIN && vertexColor.r < MAX && vertexColor.r > MIN && vertexColor.r < MAX && vertexColor.r > MIN && vertexColor.r < MAX) {
		correctedVertexColor = vec4(1);
	} else {
		correctedVertexColor = vertexColor;
	}
	
	vec4 color = texture(Sampler0, texCoord0) * correctedVertexColor * ColorModulator;
	if (color.a < 0.1) {
		discard;
	}

	
	fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
