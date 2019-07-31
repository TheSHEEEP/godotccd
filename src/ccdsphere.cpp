/*
 * Copyright (c) 2019 Jan Drabner jd at jdrabner.eu
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
#include "ccdbox.h"
#include "ccdcylinder.h"

using namespace godot;

void CCDSphere::_register_methods() 
{
    register_method("initialize", &CCDSphere::initialize);
    register_method("collidesWithGJK", &CCDSphere::collidesWithGJK);
    register_method("collidesWithMPR", &CCDSphere::collidesWithMPR);
    register_method("getPosition", &CCDSphere::getPosition);
    register_method("getClassName", &CCDSphere::getClassName);
}

CCDSphere::CCDSphere() 
    : CCDBase()
{
    // Init sphere
    ccdSphere.type = CCD_OBJ_SPHERE;
    ccdSphere.quat = { .q = { 0., 0., 0., 1. } };
}

CCDSphere::~CCDSphere() 
{
}

void 
CCDSphere::_init() 
{
}

void 
CCDSphere::initialize(Vector3 position, Quat rotation, float radius)
{
    ccdSphere.radius = radius;
    ccdSphere.pos.v[0] = position.x;
    ccdSphere.pos.v[1] = position.y;
    ccdSphere.pos.v[2] = position.z;
    ccdSphere.quat.q[0] = rotation.x;
    ccdSphere.quat.q[1] = rotation.y;
    ccdSphere.quat.q[2] = rotation.z;
    ccdSphere.quat.q[3] = rotation.w;
    testRadius = radius;
}

bool 
CCDSphere::collidesWithGJK(Variant other)
{
    // Check the actual class of the other object
    CCDSphere* sphere = Object::cast_to<CCDSphere>(other.operator Object*());
    CCDBox* box = Object::cast_to<CCDBox>(other.operator Object*());
    CCDCylinder* cylinder = Object::cast_to<CCDCylinder>(other.operator Object*());
    
    // Check collision
    bool intersect = false;
    if (sphere != nullptr)
    {
        intersect = ccdGJKIntersect(&ccdSphere, &(sphere->ccdSphere), &ccd);
    }
    else if (box != nullptr)
    {
        intersect = ccdGJKIntersect(&ccdSphere, &(box->ccdBox), &ccd);
    }
    else if (cylinder != nullptr)
    {
        intersect = ccdGJKIntersect(&ccdSphere, &(cylinder->ccdCylinder), &ccd);
    }

    return intersect;
}

bool 
CCDSphere::collidesWithGJKPenetration(Variant other, Dictionary* outParam)
{
    return true;
}

bool 
CCDSphere::collidesWithMPR(Variant other)
{
    // Check the actual class of the other object
    CCDSphere* sphere = Object::cast_to<CCDSphere>(other.operator Object*());
    CCDBox* box = Object::cast_to<CCDBox>(other.operator Object*());
    CCDCylinder* cylinder = Object::cast_to<CCDCylinder>(other.operator Object*());
    
    // Check collision
    bool intersect = false;
    if (sphere != nullptr)
    {
        intersect = ccdMPRIntersect(&ccdSphere, &(sphere->ccdSphere), &ccd);
    }
    else if (box != nullptr)
    {
        intersect = ccdMPRIntersect(&ccdSphere, &(box->ccdBox), &ccd);
    }
    else if (cylinder != nullptr)
    {
        intersect = ccdMPRIntersect(&ccdSphere, &(cylinder->ccdCylinder), &ccd);
    }

    return intersect;
}

Vector3 
CCDSphere::getPosition()
{
    return Vector3(ccdSphere.pos.v[0], ccdSphere.pos.v[1], ccdSphere.pos.v[2]);
}


