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
#include <Defs.hpp>
#include <Quat.hpp>
#include "ccd/ccd.h"
#include "testsuites/support.h"

namespace godot
{
    
    enum CCDType
    {
        CCDTYPE_INVALID = -1,
        CCDTYPE_BOX,
        CCDTYPE_SPHERE,
        CCDTYPE_CYLINDER,
        NUM_CCD_TYPES
    };
    
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
        
        /**
         * @brief Returns true if this object collides with the passed one.
         */
        bool collidesWithGJK(Variant other);
        
        /**
         * @brief   Returns true if this object collides with the passed one.
         *          Will also fill the outParam with details about the collision.
         */
        bool collidesWithGJKAndInfo(Variant other, Dictionary outParam);
        
        /**
         * @brief Returns true if this object collides with the passed one.
         */
        bool collidesWithMPR(Variant other);
        
        /**
         * @brief   Returns true if this object collides with the passed one.
         *          Will also fill the outParam with details about the collision.
         */
        bool collidesWithMPRAndInfo(Variant other, Dictionary outParam);
        
        /**
         * @brief Returns the position.
         */
        virtual Vector3 getPosition() { return Vector3(0.0f, 0.0f, 0.0f); }
        
        /**
         * @brief Returns the rotation.
         */
        virtual Quat getRotation() { return Quat(0.0f, 0.0f, 0.0f, 1.0f); }
        
        /**
         * @brief Returns the ccd struct used by this class.
         */
        virtual void* getCCDStruct() { return nullptr; }
        
        /**
         * @brief Returns the type.
         */
        virtual int getCCDType() { return CCDTYPE_INVALID; }
        
    protected:
        static ccd_t ccd;
        static bool ccdInitialized;
    };
}

#endif // CCDBASE_H
