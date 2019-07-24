# godotccd
A GDNative plugin for the [Godot Engine](https://godotengine.org/) (3.1+) that implements [libccd](https://github.com/danfis/libccd) - a lightning fast collision checking library for convex shapes.  
Features boxes, cylinders and spheres.  
Both GJK and MPR algorithms are included, so you can pick the one you want.

### What this is and isn't
**It is:** A plugin that allows extremely fast collision checking between arbitrary boxes, cylinders and spheres independent of Godot's internal simulations, scenes & rendering. And only that.  
**It isn't:** A replacement for Godot's physics or collision system.

### Why not use Godot's physics for collision checking?
I was looking for a way to do very fast collision checking without requiring any kind of existing nodes, and unrelated to Godot's physics system as that would have been too slow and cumbersome for my needs.  
Godot's collision checking is fine for most "everyday" needs, but if you need something very fast to do hundreds of checks for very simple shapes in just some milliseconds, it won't suffice.  
Hence I decided to implement [libccd](https://github.com/danfis/libccd), which is fast, lightweight and has a license fitting Godot's own.

### How to build?
Note that I build for linux 64bit release in this guide, but you can change those options, of course (check the [build system documentation](https://docs.godotengine.org/en/3.1/development/compiling/introduction_to_the_buildsystem.html)).  
I don't see a reason why this module wouldn't work on any other desktop platform.

1. Check out the repo
2. Initialize the submodules:  

```
git submodule update --init --recursive
```

3. Build Godot's cpp bindings:  
```
cd godot-cpp
scons platform=linux generate_bindings=yes bits=64 target=release -j 4
cd ..
```
4. Build godotccd:
```
scons platforms=linux target=release -j 4
```
The compiled gdnative module should now be under demo/godotccd/bin.

### How to integrate into your project?
Copy the `demo/addons/godotccd` folder to your own project, make sure to place it in an identical path, e.g. `<yourProject>/addons/godotccd`. Otherwise, the paths inside the various files won't work.  
Of course, you are free to place it anywhere, but then you'll have to adjust the paths yourself.

Please also read [this guide](https://docs.godotengine.org/en/3.1/tutorials/plugins/gdnative/gdnative-cpp-example.html#using-the-gdnative-module) on how to use C++ GDNative modules.
