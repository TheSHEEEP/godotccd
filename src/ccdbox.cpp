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

#include "ccdbox.h"
#include "ccdsphere.h"
#include "ccdcylinder.h"

using namespace godot;

void CCDBox::_register_methods() 
{
    register_method("initialize", &CCDBox::initialize);
    register_method("collidesWithGJK", &CCDBox::collidesWithGJK);
    register_method("collidesWithMPR", &CCDBox::collidesWithMPR);
    register_method("collidesWithGJKAndInfo", &CCDBox::collidesWithGJKAndInfo);
    register_method("collidesWithMPRAndInfo", &CCDBox::collidesWithMPRAndInfo);
    register_method("getPosition", &CCDBox::getPosition);
    register_method("getCCDType", &CCDBox::getCCDType);
}


CCDBox::CCDBox()
    : CCDBase()
{
    // Init sphere
    ccdBox.type = CCD_OBJ_BOX;
    ccdBox.quat = { .q = { 0., 0., 0., 1. } };
}

CCDBox::~CCDBox()
{

}

void 
CCDBox::_init() 
{
}

void 
CCDBox::initialize(Vector3 position, Quat rotation, Vector3 dimensions)
{
    ccdBox.pos.v[0] = position.x;
    ccdBox.pos.v[1] = position.z;
    ccdBox.pos.v[2] = position.y;
    ccdBox.quat.q[0] = rotation.x;
    ccdBox.quat.q[1] = rotation.z;
    ccdBox.quat.q[2] = rotation.y;
    ccdBox.quat.q[3] = rotation.w;
    ccdBox.x = dimensions.x;
    ccdBox.y = dimensions.z;
    ccdBox.z = dimensions.y;
}

bool 
CCDBox::collidesWithGJK(Variant other)
{
    return CCDBase::collidesWithGJK(other);
}

bool 
CCDBox::collidesWithGJKAndInfo(Variant other, Dictionary outParam)
{
    return CCDBase::collidesWithGJKAndInfo(other, outParam);
}

bool 
CCDBox::collidesWithMPR(Variant other)
{
    return CCDBase::collidesWithMPR(other);
}

bool 
CCDBox::collidesWithMPRAndInfo(Variant other, Dictionary outParam)
{
    return CCDBase::collidesWithMPRAndInfo(other,outParam);
}

Vector3 
CCDBox::getPosition()
{
    return Vector3(ccdBox.pos.v[0], ccdBox.pos.v[2], ccdBox.pos.v[1]);
}
