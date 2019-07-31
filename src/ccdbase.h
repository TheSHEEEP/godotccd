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

#ifndef CCDBASE_H
#define CCDBASE_H

#include <Godot.hpp>
#include <Dictionary.hpp>
#include <Variant.hpp>
#include "ccd/ccd.h"
#include "testsuites/support.h"

namespace godot
{
    
    /**
    * @todo write docs
    */
    class CCDBase : public Object
    {
        GODOT_CLASS(CCDBase, Object)
        
    public:
        static void _register_methods();
        
        /**
        * Default constructor
        */
        CCDBase();

        /**
        * Destructor
        */
        virtual ~CCDBase();

        void _init(); // our initializer called by Godot
        
    protected:
        static ccd_t ccd;
        static bool ccdInitialized;
    };
}

#endif // CCDBASE_H
