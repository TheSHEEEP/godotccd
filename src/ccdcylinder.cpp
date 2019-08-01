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

#include "ccdcylinder.h"
#include "ccdbox.h"
#include "ccdsphere.h"

using namespace godot;

void CCDCylinder::_register_methods() 
{
    register_method("initialize", &CCDCylinder::initialize);
    register_method("collidesWithGJK", &CCDCylinder::collidesWithGJK);
    register_method("collidesWithMPR", &CCDCylinder::collidesWithMPR);
    register_method("collidesWithGJKAndInfo", &CCDCylinder::collidesWithGJKAndInfo);
    register_method("collidesWithMPRAndInfo", &CCDCylinder::collidesWithMPRAndInfo);
    register_method("getPosition", &CCDCylinder::getPosition);
    register_method("getCCDType", &CCDCylinder::getCCDType);
}

CCDCylinder::CCDCylinder() 
    : CCDBase()
{
    // Init sphere
    ccdCylinder.type = CCD_OBJ_CYL;
    ccdCylinder.quat = { .q = { 0., 0., 0., 1. } };
}

CCDCylinder::~CCDCylinder() 
{
}

void 
CCDCylinder::_init() 
{
}

void 
CCDCylinder::initialize(Vector3 position, Quat rotation, float radius, float height)
{
    ccdCylinder.pos.v[0] = position.x;
    ccdCylinder.pos.v[1] = position.y;
    ccdCylinder.pos.v[2] = position.z;
    ccdCylinder.quat.q[0] = rotation.x;
    ccdCylinder.quat.q[1] = rotation.y;
    ccdCylinder.quat.q[2] = rotation.z;
    ccdCylinder.quat.q[3] = rotation.w;
    ccdCylinder.radius = radius;
    ccdCylinder.height = height;
}

bool 
CCDCylinder::collidesWithGJK(Variant other)
{
    return CCDBase::collidesWithGJK(other);
}

bool 
CCDCylinder::collidesWithGJKAndInfo(Variant other, Dictionary outParam)
{
    return CCDBase::collidesWithGJKAndInfo(other, outParam);
}

bool 
CCDCylinder::collidesWithMPR(Variant other)
{
    return CCDBase::collidesWithMPR(other);
}

bool 
CCDCylinder::collidesWithMPRAndInfo(Variant other, Dictionary outParam)
{
    return CCDBase::collidesWithMPRAndInfo(other,outParam);
}

Vector3 
CCDCylinder::getPosition()
{
    return Vector3(ccdCylinder.pos.v[0], ccdCylinder.pos.v[1], ccdCylinder.pos.v[2]);
}
