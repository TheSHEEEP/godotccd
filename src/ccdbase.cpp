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

#include "ccdbase.h"

using namespace godot;

ccd_t CCDBase::ccd;
bool CCDBase::ccdInitialized = false;

void 
CCDBase::_register_methods() 
{
}

CCDBase::CCDBase()
{
    // Setup CCD
    if (!ccdInitialized) 
    {
        CCD_INIT(&ccd);
        ccd.support1        = ccdSupport;   // support function for first object
        ccd.support2        = ccdSupport;   // support function for second object
        ccd.center1         = ccdObjCenter; // center function for first
        ccd.center2         = ccdObjCenter; // center function for second
        ccd.max_iterations  = 100;          // maximal number of iterations
        ccd.epa_tolerance   = 0.1f;
        ccd.mpr_tolerance   = 0.1f;
        ccd.dist_tolerance  = 0.1f;
        ccdInitialized      = true;
    }
}

CCDBase::~CCDBase()
{

}

void 
CCDBase::_init() 
{
}

