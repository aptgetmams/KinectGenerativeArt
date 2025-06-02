#version 300 es
precision mediump float;
out vec4 fragColor;

uniform sampler2D depthTexture;

void main() {
    vec2 uv = gl_FragCoord.xy / vec2(640.0, 480.0);
    fragColor = texture(depthTexture, uv);
}
