# godotccd
A GDNative plugin for the [Godot Engine](https://godotengine.org/) (3.1+) that implements [libccd](https://github.com/danfis/libccd) - a lightning fast collision checking library for convex shapes.

### Why not use Godot's physics for collision?
I was looking for a way to do very fast collision checking without requiring any kind of existing nodes, and unrelated to Godot's physics system as that would have been too slow and cumbersome for my needs.  
Godot's collision checking is fine for most "everyday" needs, but if you need something very fast to do hundreds of checks in just some milliseconds, it won't do.  
Hence I decided to implement [libccd](https://github.com/danfis/libccd), which is fast, very lightweight and has a license fitting Godot's own.

### How to build?
1. Check out the repo
2. Initialize the submodules:  

```
git submodules update --init --recursive
```

3. Build Godot's cpp bindings (those are the settings I use, for other choices, check out the [build system documentation](https://docs.godotengine.org/en/3.1/development/compiling/introduction_to_the_buildsystem.html)):  
```
cd godot-cpp
scons platform=linux generate_bindings=yes bits=64 target=release -j 4
cd ..
```
4. Build godotccd:
```
hello
```
