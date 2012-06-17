//
//  sEnvironmentMapping.fsh
//
//  Created by Anton Holmquist
//  Copyright 2012 Anton Holmquist. All rights reserved.
// 
//  http://antonholmquist.com
//  http://twitter.com/antonholmquist
//
//  http://github.com/antonholmquist/opengl-es-2-0-shaders
//

precision highp float;

// Environment map
uniform lowp samplerCube s_environmentMap;

// Varyings
varying vec3 v_ecPosition;
varying vec3 v_ecNormal;

void main() { 
    
    // Normalize v_ecNormal
    vec3 ecNormal = v_ecNormal / length(v_ecNormal);
    
    // Calculate reflection vector
    vec3 ecEyeReflection = reflect(v_ecPosition, ecNormal);
    
    // Sample environment color
    vec4 environmentColor = textureCube(s_environmentMap, ecEyeReflection);
    
    gl_FragColor = environmentColor;
}
