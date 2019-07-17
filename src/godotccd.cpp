#include "godotccd.h"

using namespace godot;

void GDExample::_register_methods() {
    register_method("_process", &GDExample::_process);
    register_method("saySomething", &GDExample::saySomething);
}

GDExample::GDExample() 
{
}

GDExample::~GDExample() 
{
    // add your cleanup here
}

void GDExample::_init() 
{
    // initialize any variables here
    time_passed = 0.0;
}

void GDExample::_process(float delta) 
{
    time_passed += delta;

    if (time_passed >= 2.0f) 
    {
        Godot::print("2 seconds passed.");
        time_passed = 0.0f;
    }
}

void GDExample::saySomething()
{
    Godot::print("Hello world!");
}

