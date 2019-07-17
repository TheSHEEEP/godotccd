/*
 * Copyright (c) 2019 <copyright holder> <email>
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#include "ccdsphere.h"

using namespace godot;

void CCDSphere::_register_methods() 
{
    register_method("initialize", &CCDSphere::initialize);
}

CCDSphere::CCDSphere() 
{
    ccdSphere.type = CCD_OBJ_SPHERE;
    ccdSphere.quat = { .q = { 0., 0., 0., 1. } };
}

CCDSphere::~CCDSphere() 
{
}

void CCDSphere::_init() 
{
}

void CCDSphere::initialize(Vector3 position, float radius)
{
    Godot::print("Init sphere with {0} and {1}", position, radius);
    
    ccdSphere.radius = radius;
    ccdSphere.pos.v[0] = position.x;
    ccdSphere.pos.v[1] = position.y;
    ccdSphere.pos.v[2] = position.z;
    
    Godot::print("Check {0}", ccdSphere.pos.v[2]);
}


