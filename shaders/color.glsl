#ifndef COLOR_GLSL_INCLUDED
#define COLOR_GLSL_INCLUDED

// sRGB-encoded value (what the bytes of a colour texture mean) -> linear light.
// The exact piecewise curve, not pow(c, 2.2).
vec3 srgb_to_linear(vec3 c) {
    return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(0.04045, c));
}

// Linear light -> sRGB-encoded value (what the UNORM target and the screen expect).
// The exact inverse of srgb_to_linear.
vec3 linear_to_srgb(vec3 c) {
    return mix(12.92 * c, 1.055 * pow(c, 1.0 / vec3(2.4)) - 0.055, step(0.0031308, c));
}

// A debug view for albedo textures: luminance of the LINEAR colour, too dark
// (< 0.04) shows blue, too bright (> 0.9) shows red, anything else shows that
// luminance as a grey, encoded for display.
vec3 albedo_check(vec3 lin) {
    float luminance = 0.2126 * lin.r + 0.7152 * lin.g + 0.0722 * lin.b;
    vec3 bw = linear_to_srgb(vec3(luminance));
    vec3 filter_bright = mix(bw, vec3(1.0, 0.0, 0.0), step(0.9, luminance));
    vec3 filter_dark = mix(vec3(0.0, 0.0, 1.0), filter_bright, step(0.04, luminance));
    return filter_dark;
}

#endif
