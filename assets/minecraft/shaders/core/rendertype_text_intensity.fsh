#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
	vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
	if (color.a < 0.1) {
		discard;
	}
	
	// GUI text color hack fix, the alternitive is language files for *every* language.
	if (vertexDistance > 100.0 && color.r > 0.248 && color.r < 0.25) color = vec4(1);
	
	fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
