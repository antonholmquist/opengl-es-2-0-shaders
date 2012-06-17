//
//  sVertexLighting.vsh
//
//  Created by Anton Holmquist
//  Copyright 2012 Anton Holmquist. All rights reserved.
//
//  http://antonholmquist.com
//

struct DirectionalLight {
    vec3 direction;
    vec3 halfplane;
    vec4 ambientColor;
    vec4 diffuseColor;
    vec4 specularColor;
};

struct Material {
    vec4 ambientFactor;
    vec4 diffuseFactor;
    vec4 specularFactor;
    float shininess;
};

// Light
uniform DirectionalLight u_directionalLight;

// Material
uniform Material u_material;

// Matrices
uniform mat4 u_mvMatrix;
uniform mat4 u_mvpMatrix;

// Attributes
attribute vec4 a_position; 
attribute vec3 a_normal;

// Varyings
varying vec4 v_light;

void main() {
    
    // Define position and normal in model coordinates
    vec4 mcPosition = a_position;
    vec3 mcNormal = a_normal;
    
    // Calculate and normalize eye space normal
    vec3 ecNormal = vec3(u_mvMatrix * vec4(mcNormal, 0.0));
    ecNormal = ecNormal / length(ecNormal);
    

    float ecNormalDotLightDirection = max(0.0, dot(ecNormal, u_directionalLight.direction));
    float ecNormalDotLightHalfplane = max(0.0, dot(ecNormal, u_directionalLight.halfplane));
    
    // Calculate ambient light
    vec4 ambientLight = u_directionalLight.ambientColor * u_material.ambientFactor;
    
    // Calculate diffuse light
    vec4 diffuseLight = ecNormalDotLightDirection * u_directionalLight.diffuseColor * u_material.diffuseFactor;
    
    // Calculate specular light
    vec4 specularLight = vec4(0.0);
    if (ecNormalDotLightHalfplane > 0.0) {
        specularLight = pow(ecNormalDotLightHalfplane, u_material.shininess) * u_directionalLight.specularColor * u_material.specularFactor;
    } 
    
    v_light = ambientLight + diffuseLight + specularLight;
    gl_Position = u_mvpMatrix * mcPosition;    
    
}


