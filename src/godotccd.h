#ifndef GODOTCCD_H
#define GODOTCCD_H

#include <Godot.hpp>
#include <Reference.hpp>

namespace godot
{
    class GDExample : public Reference
    {
        GODOT_CLASS(GDExample, Reference)

    private:
        float time_passed;

    public:
        static void _register_methods();

        GDExample();
        ~GDExample();

        void _init(); // our initializer called by Godot

        void _process(float delta);
        
        /**
         * Will say something.
         */
        void saySomething();
    };

} // END namespace
#endif
