// http://stackoverflow.com/questions/12030101/an-outline-sharp-transition-in-a-fragment-shader

//float outline(float t, float threshold, float width) {
//  return clamp(width - abs(threshold - t) / fwidth(t), 0.0, 1.0);
//}



#pragma transparent




//_output.color.bg = mix(_output.color.rb, (1.0 - dot(_surface.view, _surface.normal)) * _output.color.bg, 1.0);

float dotProduct = dot(_surface.view, _surface.normal);

_output.color.rb = mix(_output.color.rb, vec2(dotProduct, 1.0 - dotProduct), 0.5);

//_output.color.rgb = mix(_output.color.rgb, vec3(0.0, 0.0, 0.0), dotProduct);
