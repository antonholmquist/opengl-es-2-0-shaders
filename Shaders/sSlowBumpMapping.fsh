//
//  sFragmentLighting.fsh
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

uniform mat4 u_mvMatrix;

// Light
uniform DirectionalLight u_directionalLight;

// Material
uniform Material u_material;

varying vec3 v_mcNormal;
varying vec3 v_mcTangent;

uniform sampler2D s_texture;
uniform sampler2D s_normalMap;

varying vec2 v_texCoord;

mat3 transpose(mat3 matrix) {
    mat3 outMatrix;
    outMatrix[0][0] = matrix[0][0];
    outMatrix[1][1] = matrix[1][1];
    outMatrix[2][2] = matrix[2][2];
    
    outMatrix[0][1] = matrix[1][0];
    outMatrix[1][0] = matrix[0][1];
    
    outMatrix[2][0] = matrix[0][2];
    outMatrix[0][2] = matrix[2][0];
    
    outMatrix[1][2] = matrix[2][1];
    outMatrix[2][1] = matrix[1][2];
    
    return outMatrix;
}

void main() { 
    
    vec4 texel = texture2D(s_texture, v_texCoord);
    
    vec3 tcTextureNormal = texture2D(s_normalMap, v_texCoord).xyz;
    tcTextureNormal = (tcTextureNormal - vec3(0.5)) * 2.0;
    tcTextureNormal = tcTextureNormal / length(tcTextureNormal);
    
    // Create ec to tc matrix
    mat3 ec2tcMatrix;
    vec3 n = vec3(u_mvMatrix * vec4(v_mcNormal, 0.0));
    vec3 t = vec3(u_mvMatrix * vec4(v_mcTangent, 0.0));
    ec2tcMatrix[0] = t / length(t);
    ec2tcMatrix[2] = n / length(n);
    ec2tcMatrix[1] = cross(ec2tcMatrix[2], ec2tcMatrix[0]); 
    ec2tcMatrix = transpose(ec2tcMatrix);
    
    
    // Calculate and normalize eye space normal
    vec3 ecNormal = vec3(u_mvMatrix * vec4(v_mcNormal, 0.0));
    ecNormal = ecNormal / length(ecNormal);
    
    vec3 tcNormal = tcTextureNormal; 
    
    // Convert light directions to tangent space
    vec3 tcLightDirection = ec2tcMatrix * u_directionalLight.direction;
    vec3 tcLightHalfplane = ec2tcMatrix * u_directionalLight.halfplane;
    
    float ecNormalDotLightDirection = max(0.0, dot(tcNormal, tcLightDirection));
    float ecNormalDotLightHalfplane = max(0.0, dot(tcNormal, tcLightHalfplane));
    
    // Calculate ambient light
    vec4 ambientLight = u_directionalLight.ambientColor * u_material.ambientFactor;
    
    // Calculate diffuse light
    vec4 diffuseLight = ecNormalDotLightDirection * u_directionalLight.diffuseColor * u_material.diffuseFactor;
    
    // Calculate specular light
    vec4 specularLight = vec4(0.0);
    if (ecNormalDotLightHalfplane > 0.0) {
        specularLight = pow(ecNormalDotLightHalfplane, u_material.shininess) * u_directionalLight.specularColor * u_material.specularFactor;
    } 
    
    vec4 light = ambientLight + diffuseLight + specularLight;
    
    gl_FragColor = texel * (ambientLight + diffuseLight) + specularLight;

}
