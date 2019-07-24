extends Spatial
const CCDSphere = preload("res://addons/godotccd/ccdSphere.gdns")

var isDoingTest 	:bool = false
var testIndex 		:int = -1
var rng 			:RandomNumberGenerator = RandomNumberGenerator.new()
var objectContainer :Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var sphere = CCDSphere.new()
	sphere.initialize(Vector3(1.1, 2.2, 3.3), 4.4)

# Called when the user presses a key
func _input(event :InputEvent) -> void:
	# Quit the application
	if event.is_action("ui_cancel") && event.is_pressed():
		get_tree().quit()
	# Start the next test
	if event.is_action("ui_select") && event.is_pressed():
		if isDoingTest:
			return
		else:
			testIndex += 1
			doNextTest(testIndex)

# Starts one of the tests
func doNextTest(testIndex :int) -> void:
	if testIndex == 0:
		$lblAdvance.bbcode_text = "[center]Doing area test... patience, please[/center]"
		yield(doAreaTest(500), "completed")
		$lblAdvance.bbcode_text = "[center]Area test done. Press space to run the next test...[/center]"

# Do the area test
func doAreaTest(numObjects :int) -> void:
	isDoingTest = true
	
	# Box vs Box test
	objectContainer.clear()
	var timerStart :int = OS.get_ticks_msec()
	rng.seed = 1
	var numCollisions :int = yield(_internalAreaTest($BoxArea, null, numObjects), "completed")
	var timerEnd :int = OS.get_ticks_msec()
	var timeTotal :int = timerEnd - timerStart
	var bbCode :String = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer2/lblAreaBB.bbcode_text = bbCode
	
	# Sphere vs Sphere test
	objectContainer.clear()
	timerStart = OS.get_ticks_msec()
	rng.seed = 2
	numCollisions = yield(_internalAreaTest($SphereArea, null, numObjects), "completed")
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer2/lblAreaSS.bbcode_text = bbCode
	
	# Cylinder vs Cylinder test
	objectContainer.clear()
	timerStart = OS.get_ticks_msec()
	rng.seed = 3
	numCollisions = yield(_internalAreaTest($CylinderArea, null, numObjects), "completed")
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer2/lblAreaCC.bbcode_text = bbCode
	
	# Box vs Sphere test
	objectContainer.clear()
	timerStart = OS.get_ticks_msec()
	rng.seed = 4
	numCollisions = yield(_internalAreaTest($BoxArea, $SphereArea, numObjects), "completed")
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer2/lblAreaBS.bbcode_text = bbCode
	
	# Box vs Cylinder test
	objectContainer.clear()
	timerStart = OS.get_ticks_msec()
	rng.seed = 5
	numCollisions = yield(_internalAreaTest($BoxArea, $CylinderArea, numObjects), "completed")
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer2/lblAreaBC.bbcode_text = bbCode
	
	# Sphere vs Cylinder test
	objectContainer.clear()
	timerStart = OS.get_ticks_msec()
	rng.seed = 6
	numCollisions = yield(_internalAreaTest($SphereArea, $CylinderArea, numObjects), "completed")
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer2/lblAreaSC.bbcode_text = bbCode
	
	# Done
	isDoingTest = false

# Internal test for Godot's area type
func _internalAreaTest(originalArea :Area, originalArea2 :Area, numObjects :int) -> int:
	var numCollisions :int = 0
	
	# Add the first area
	var area :Area = originalArea.duplicate()
	area.translation = Vector3(rng.randf_range(0.0, 50.0), 0.0, rng.randf_range(0.0, 50.0))
	add_child(area)
	objectContainer.push_back(area)
	
	# Add the rest of the areas and check for collision with the rest
	for i in range(0, numObjects-1):
		# Add area
		if i % 2 == 1 && originalArea2 != null:
			area = originalArea2.duplicate()
		else:
			area = originalArea.duplicate()
		area.translation = Vector3(rng.randf_range(0.0, 50.0), 0.0, rng.randf_range(0.0, 50.0))
		add_child(area)
		
		# Two-three physics_frame seem to be the required minimum until Godot "knows" about colliding areas
		# This might be depending on the machine running the code, but even having to wait one frame means waiting too long...
		yield(get_tree(), "physics_frame")
		yield(get_tree(), "physics_frame")
		
		# Check collision with the existing areas until one collision happens
		for other in objectContainer:
			var collides :bool = area.overlaps_area(other)
			if collides:
				numCollisions += 1
				break
		
		objectContainer.push_back(area)
	
	# Done
	return numCollisions