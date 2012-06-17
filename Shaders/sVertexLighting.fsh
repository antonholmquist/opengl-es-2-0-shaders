//
//  sVertexLighting.fsh
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

varying vec4 v_light;

void main() { 
    gl_FragColor = v_light;
}
