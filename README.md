# godotccd
A GDNative plugin for the [Godot Engine](https://godotengine.org/) (3.1+) that implements [libccd](https://github.com/danfis/libccd) - a lightning fast collision checking library for convex shapes.  
Features boxes, cylinders and spheres.  
Both GJK and MPR algorithms are included, so you can pick the one you want.

### What this is and isn't
**It is:** A module that allows extremely fast collision checking between arbitrary boxes, cylinders and spheres independent of Godot's internal simulations, scenes & rendering. And only that.  
**It isn't:** A replacement for Godot's physics or collision system.

### Why not use Godot's physics for collision checking?
I was looking for a way to do very fast collision checking without requiring any kind of existing nodes, and unrelated to Godot's physics system as that would have been too slow and cumbersome for my needs.  
Godot's collision checking is fine for most "everyday" needs, but if you need something very fast to do hundreds of checks for very simple shapes in just some milliseconds, it won't suffice.  

The reason why Godot's physics is not sufficient for all cases is that Godot requires multiple physics frames until collision checks between objects in its physics world can even work. After something is added or moved, some physics frames need to pass until you can check for collisions.  
That just doesn't cut it if you need maximum performance for a collision check **right now**.

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

### How to use?

First of all, make sure the native scripts are loaded:
```GDScript
const CCDBox 		:NativeScript = preload("res://addons/godotccd/ccdBox.gdns")
const CCDSphere 	:NativeScript = preload("res://addons/godotccd/ccdSphere.gdns")
const CCDCylinder 	:NativeScript = preload("res://addons/godotccd/ccdCylinder.gdns")
```

After that, you can create a sphere, box or cylinder using those NativeScript objects:
```GDScript
var ccdBox :Object = CCDBox.new()
var ccdSphere :Object = CCDSphere.new()
var ccdCylinder :Object = CCDCylinder.new()
```

Remember that you need to initialize() any shape to give it its proper measurement:
```GDScript
# Parameters for CCDBox are position, rotation (as a Quat), xyz-dimensions
ccdBox.initialize(Vector3(0.0, 0.0, 0.0), Quat.IDENTITY, Vector3(2.0, 2.0, 2.0))

# Parameters for CCDSphere are position, rotation (as a Quat), radius
ccdSphere.initialize(Vector3(0.0, 0.0, 0.0), Quat.IDENTITY, 1.5)

# Parameters for CCDCylinder are position, rotation (as a Quat), radius, height
ccdCylinder.initialize(Vector3(0.0, 0.0, 0.0), Quat.IDENTITY, 1.0, 2.0)
```
At some point, I might add functions that automatically initialize CCD shapes from a given Godot shape or Area, but for now, you gotta do it manually. Or submit a pull request ;)

To perform a collision check:
```GDScript
# Either use GJK...
var collision :bool = ccdBox.collidesWithGJK(ccdSphere)
# ... or MPR
collision :bool = ccdBox.collidesWithMPR(ccdSphere)
```

And to perform a collision check with an out-parameter filled with details about the collision:
```GDScript
# The out-parameter must be a Dictionary
var collisionInfo :Dictionary = {}
var collision :bool = ccdBox.collidesWithGJKPlusInfo(ccdSphere, collisionInfo)
# ... or MPR
collision :bool = ccdBox.collidesWithMPRPlusInfo(ccdSphere, collisionInfo)

# In both cases, the Dictionary will either be unchanged (if no collision) or hold the following keys
var
```
Please note that this will take a bit longer to calculate than doing "just" a collision check. So make sure to only use it if you need the collision data.

Finally, there are a few functions to get info at runtime from the godotccd shapes:
```GDScript
var position :Vector3 = someCCDShape.getPosition()

# Types are: 0 = CCDBox, 1 = CCDSphere, 2 = CCDCylinder
var type :int = someCCDShape.getCCDType()
```
Again, I might add more here if the need comes up.

### Is there a demo?

There is! And it showcases the extreme speed difference between doing collision checks with freshly added shapes via Godot's Area and godotccd shapes.  

To be fair, though, it also shows that the fastest variant is actually Godot's area after all shapes have been added and "registered" by its physics world. Of course, that is only fast as long as nothing moves or is removed/added, etc. which isn't realistic in all cases - hence the need for this module.

Simply open the project under /demo. But don't forget to compile the module first.

### Hints

**Generous Cylinders:** Please note that both GJK and MPR methods always (at least in my tests) find a few more collisions when cylinders are involved than Godot's Area.  
If that is down to Godot's physics not knowing about all objects yet or if libccd is more "generous" in what it considers an intersection or if one of the libraries' cylinder math is faulty - unknown.  
If this is a problem for your case, you might be better off not using cylinders, or decreasing their size for godotccd.

**Prepare Your Shapes:** Since there is a rather large cost in creating new native objects from GDScript (as well as a certain overhead in calling native functions), it is wise to have the boxes, spheres and cylinders you need created beforehand. Even initialized, if possible.  
Not strictly necessary, mind you, as it is still very fast doing ad-hoc as the demo shows. But if you're using this module, you probably need to squeeze as much performance as possible.

**GJK vs MPR:** Supposedly, MPR is faster, but a bit less accurate. In my tests, I couldn't really see any difference in performance (and I did my demo test with up to 10000 comparisons...). And neither could I find any significant difference in accuracy. Maybe those differences would show up with much larger/smaller objects.  
But as it is, I have a no real recommendation here.
