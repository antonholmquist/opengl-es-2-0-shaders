//
//  sFragmentLighting.vsh
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

// Matrices
uniform mat4 u_mvMatrix;
uniform mat4 u_mvpMatrix;

// Attributes
attribute vec4 a_position; 
attribute vec3 a_normal;
attribute vec3 a_tangent;
attribute vec2 a_texCoord;

// Varyings
varying vec3 v_mcNormal;
varying vec3 v_mcTangent;
varying vec2 v_texCoord;


void main() {

    //float displacement = texture2D(s_displacementMap, a_texCoord).r - 0.5;
    
    v_texCoord = a_texCoord;
    v_mcTangent = a_tangent;
    
    // Define position and normal in model coordinates
    vec4 mcPosition = a_position; // + displacement * vec4(a_normal, 0.0) * 15.0;
    vec3 mcNormal = a_normal;
    
    v_mcNormal = a_normal;
    
    gl_Position = u_mvpMatrix * mcPosition;    
    
}


