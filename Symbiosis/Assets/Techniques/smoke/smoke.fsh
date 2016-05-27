// Modified again from here: https://gist.github.com/underscorediscovery/10324388

// Modified version of a tilt shift shader from Martin Jonasson (http://grapefrukt.com/)
// Read http://notes.underscorediscovery.com/ for context on shaders and this file
// License : MIT

uniform sampler2D colorSampler;
varying vec2 uv;

const vec2 center = vec2(0.5, 0.5);
const float gradientSize = 0.5;
const float ovalPos = 0.8;
const float attenuation = 0.6;

void main() {
    
    float fromCenter;
    float maxDist;
    vec4 color;
    
    maxDist = distance(center, vec2(0.0, 0.0));
    color = texture2D(colorSampler, uv).rgba;
    fromCenter = distance(uv, center) * (1.0 / maxDist);
    
    float distFromOval = ovalPos - fromCenter;
    float val = 1.0 - ((clamp(distFromOval, -gradientSize/2.0, gradientSize/2.0) + gradientSize/2.0) * (1.0 / gradientSize));
    float valExp = val * val;

    gl_FragColor = mix(color, vec4(0.05, 0.0, 0.1, 1.0), valExp * attenuation);
    
}

