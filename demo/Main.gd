extends Spatial
const CCDSphere 	:NativeScript = preload("res://addons/godotccd/ccdSphere.gdns")
const CCDBox 		:NativeScript = preload("res://addons/godotccd/ccdBox.gdns")
const CCDCylinder 	:NativeScript = preload("res://addons/godotccd/ccdCylinder.gdns")
const objectRange 	:float = 75.0
const numTests		:int = 300

var isDoingTest 	:bool = false
var testIndex 		:int = -1
var rng 			:RandomNumberGenerator = RandomNumberGenerator.new()
var objectContainer :Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var text :String = $lblDescription.text
	text = text.replace("_X_", str(numTests))
	text = text.replace("_X-1_", str(numTests - 1))
	$lblDescription.text = text

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
		yield(doAreaTest(numTests), "completed")
		$lblAdvance.bbcode_text = "[center]Area test done. Press space to run the next test...[/center]"
	if testIndex == 1:
		$lblAdvance.bbcode_text = "[center]Doing godotccd GJK test...[/center]"
		yield(doCCDGJKTest(numTests), "completed")
		$lblAdvance.bbcode_text = "[center]godotccd GJK test done. Press space to run the next test...[/center]"
	if testIndex == 2:
		$lblAdvance.bbcode_text = "[center]Doing godotccd MPR test...[/center]"
		yield(doCCDMPRTest(numTests), "completed")
		$lblAdvance.bbcode_text = "[center]godotccd MPR test done. Press space to run the next test...[/center]"
	if testIndex == 3:
		$lblAdvance.bbcode_text = "[center]Doing GJK & MPR with info test...[/center]"
		yield(doInfoTest(numTests), "completed")
		$lblAdvance.bbcode_text = "[center]All tests done. Hooray! (>^.^)>[/center]"

# Do the area test
func doAreaTest(numObjects :int) -> void:
	isDoingTest = true
	
	# Box vs Box test
	_clearObjectsArea()
	var timerStart :int = OS.get_ticks_msec()
	rng.seed = 1
	var outParam :Dictionary = { "result" : 0 }
	yield(_internalAreaTest($BoxArea, null, numObjects, false, outParam), "completed")
	var numCollisions :int = outParam["result"]
	var timerEnd :int = OS.get_ticks_msec()
	var timeTotal :int = timerEnd - timerStart
	_clearObjectsArea()
	rng.seed = 1
	yield(_internalAreaTest($BoxArea, null, numObjects, true, outParam), "completed")
	var numCollisions2 :int = outParam["result"]
	var timerEnd2 :int = OS.get_ticks_msec()
	var timeTotal2 :int = timerEnd2 - timerEnd
	var bbCode :String = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer2/lblAreaBB.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Sphere vs Sphere test
	_clearObjectsArea()
	timerStart = OS.get_ticks_msec()
	rng.seed = 2
	yield(_internalAreaTest($SphereArea, null, numObjects, false, outParam), "completed")
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	_clearObjectsArea()
	rng.seed = 2
	yield(_internalAreaTest($SphereArea, null, numObjects, true, outParam), "completed")
	numCollisions2 = outParam["result"]
	timerEnd2 = OS.get_ticks_msec()
	timeTotal2 = timerEnd2 - timerEnd
	bbCode = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer2/lblAreaSS.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Cylinder vs Cylinder test
	_clearObjectsArea()
	timerStart = OS.get_ticks_msec()
	rng.seed = 3
	yield(_internalAreaTest($CylinderArea, null, numObjects, false, outParam), "completed")
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	_clearObjectsArea()
	rng.seed = 3
	yield(_internalAreaTest($CylinderArea, null, numObjects, true, outParam), "completed")
	numCollisions2 = outParam["result"]
	timerEnd2 = OS.get_ticks_msec()
	timeTotal2 = timerEnd2 - timerEnd
	bbCode = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer2/lblAreaCC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Box vs Sphere test
	_clearObjectsArea()
	timerStart = OS.get_ticks_msec()
	rng.seed = 4
	yield(_internalAreaTest($BoxArea, $SphereArea, numObjects, false, outParam), "completed")
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	_clearObjectsArea()
	rng.seed = 4
	yield(_internalAreaTest($BoxArea, $SphereArea, numObjects, true, outParam), "completed")
	numCollisions2 = outParam["result"]
	timerEnd2 = OS.get_ticks_msec()
	timeTotal2 = timerEnd2 - timerEnd
	bbCode = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer2/lblAreaBS.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Box vs Cylinder test
	_clearObjectsArea()
	timerStart = OS.get_ticks_msec()
	rng.seed = 5
	yield(_internalAreaTest($BoxArea, $CylinderArea, numObjects, false, outParam), "completed")
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	_clearObjectsArea()
	rng.seed = 5
	yield(_internalAreaTest($BoxArea, $CylinderArea, numObjects, true, outParam), "completed")
	numCollisions2 = outParam["result"]
	timerEnd2 = OS.get_ticks_msec()
	timeTotal2 = timerEnd2 - timerEnd
	bbCode = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer2/lblAreaBC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Sphere vs Cylinder test
	_clearObjectsArea()
	timerStart = OS.get_ticks_msec()
	rng.seed = 6
	yield(_internalAreaTest($SphereArea, $CylinderArea, numObjects, false, outParam), "completed")
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	_clearObjectsArea()
	rng.seed = 6
	yield(_internalAreaTest($SphereArea, $CylinderArea, numObjects, true, outParam), "completed")
	numCollisions2 = outParam["result"]
	timerEnd2 = OS.get_ticks_msec()
	timeTotal2 = timerEnd2 - timerEnd
	bbCode = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer2/lblAreaSC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Done
	isDoingTest = false

# Do the ccd gjk test
func doCCDGJKTest(numObjects :int) -> void:
	isDoingTest = true
	
	# Box vs Box test
	var timerStart :int = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 1
	var outParam :Dictionary = { "result" : 0 }
	_internalGJKTest(CCDBox, null, numObjects, outParam)
	var numCollisions :int = outParam["result"]
	var timerEnd :int = OS.get_ticks_msec()
	var timeTotal :int = timerEnd - timerStart
	var bbCode :String = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer3/lblGJKBB.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Sphere vs Sphere test
	timerStart = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 2
	_internalGJKTest(CCDSphere, null, numObjects, outParam)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer3/lblGJKSS.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Cylinder vs Cylinder test
	timerStart = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 3
	_internalGJKTest(CCDCylinder, null, numObjects, outParam)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer3/lblGJKCC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Box vs Sphere test
	timerStart = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 4
	_internalGJKTest(CCDBox, CCDSphere, numObjects, outParam)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer3/lblGJKBS.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Box vs Cylinder test
	timerStart = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 5
	_internalGJKTest(CCDBox, CCDCylinder, numObjects, outParam)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer3/lblGJKBC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Sphere vs Cylinder test
	timerStart = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 6
	_internalGJKTest(CCDSphere, CCDCylinder, numObjects, outParam)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer3/lblGJKSC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Done
	isDoingTest = false

# Do the ccd mpr test
func doCCDMPRTest(numObjects :int) -> void:
	isDoingTest = true
	
	# Box vs Box test
	var timerStart :int = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 1
	var outParam :Dictionary = { "result" : 0 }
	_internalMPRTest(CCDBox, null, numObjects, outParam)
	var numCollisions :int = outParam["result"]
	var timerEnd :int = OS.get_ticks_msec()
	var timeTotal :int = timerEnd - timerStart
	var bbCode :String = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer4/lblMPRBB.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Sphere vs Sphere test
	timerStart = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 2
	_internalMPRTest(CCDSphere, null, numObjects, outParam)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer4/lblMPRSS.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Cylinder vs Cylinder test
	timerStart = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 3
	_internalMPRTest(CCDCylinder, null, numObjects, outParam)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer4/lblMPRCC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Box vs Sphere test
	timerStart = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 4
	_internalMPRTest(CCDBox, CCDSphere, numObjects, outParam)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer4/lblMPRBS.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Box vs Cylinder test
	timerStart = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 5
	_internalMPRTest(CCDBox, CCDCylinder, numObjects, outParam)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer4/lblMPRBC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Sphere vs Cylinder test
	timerStart = OS.get_ticks_msec()
	objectContainer.clear()
	rng.seed = 6
	_internalMPRTest(CCDSphere, CCDCylinder, numObjects, outParam)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	bbCode = "[center]{0}ms ({1})[/center]".format([timeTotal, numCollisions])
	$VBoxContainer/HBoxContainer4/lblMPRSC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Done
	isDoingTest = false

# Do the area test
func doInfoTest(numObjects :int) -> void:
	isDoingTest = true
	
	# Box vs Box test
	objectContainer.clear()
	var timerStart :int = OS.get_ticks_msec()
	rng.seed = 1
	var outParam :Dictionary = { "result" : 0 }
	_internalGJKTest(CCDBox, null, numObjects, outParam, true)
	var numCollisions :int = outParam["result"]
	var timerEnd :int = OS.get_ticks_msec()
	var timeTotal :int = timerEnd - timerStart
	objectContainer.clear()
	rng.seed = 1
	_internalMPRTest(CCDBox, null, numObjects, outParam, true)
	var numCollisions2 :int = outParam["result"]
	var timerEnd2 :int = OS.get_ticks_msec()
	var timeTotal2 :int = timerEnd2 - timerEnd
	var bbCode :String = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer5/lblInfoBB.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Sphere vs Sphere test
	objectContainer.clear()
	timerStart = OS.get_ticks_msec()
	rng.seed = 2
	_internalGJKTest(CCDSphere, null, numObjects, outParam, true)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	objectContainer.clear()
	rng.seed = 2
	_internalMPRTest(CCDSphere, null, numObjects, outParam, true)
	numCollisions2 = outParam["result"]
	timerEnd2 = OS.get_ticks_msec()
	timeTotal2 = timerEnd2 - timerEnd
	bbCode = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer5/lblInfoSS.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Cylinder vs Cylinder test
	objectContainer.clear()
	timerStart = OS.get_ticks_msec()
	rng.seed = 3
	_internalGJKTest(CCDCylinder, null, numObjects, outParam, true)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	objectContainer.clear()
	rng.seed = 3
	_internalMPRTest(CCDCylinder, null, numObjects, outParam, true)
	numCollisions2 = outParam["result"]
	timerEnd2 = OS.get_ticks_msec()
	timeTotal2 = timerEnd2 - timerEnd
	bbCode = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer5/lblInfoCC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Box vs Sphere test
	objectContainer.clear()
	timerStart = OS.get_ticks_msec()
	rng.seed = 4
	_internalGJKTest(CCDBox, CCDSphere, numObjects, outParam, true)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	objectContainer.clear()
	rng.seed = 4
	_internalMPRTest(CCDBox, CCDSphere, numObjects, outParam, true)
	numCollisions2 = outParam["result"]
	timerEnd2 = OS.get_ticks_msec()
	timeTotal2 = timerEnd2 - timerEnd
	bbCode = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer5/lblInfoBS.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Box vs Cylinder test
	objectContainer.clear()
	timerStart = OS.get_ticks_msec()
	rng.seed = 5
	_internalGJKTest(CCDBox, CCDCylinder, numObjects, outParam, true)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	objectContainer.clear()
	rng.seed = 5
	_internalMPRTest(CCDBox, CCDCylinder, numObjects, outParam, true)
	numCollisions2 = outParam["result"]
	timerEnd2 = OS.get_ticks_msec()
	timeTotal2 = timerEnd2 - timerEnd
	bbCode = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer5/lblInfoBC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Sphere vs Cylinder test
	objectContainer.clear()
	timerStart = OS.get_ticks_msec()
	rng.seed = 6
	_internalGJKTest(CCDSphere, CCDCylinder, numObjects, outParam, true)
	numCollisions = outParam["result"]
	timerEnd = OS.get_ticks_msec()
	timeTotal = timerEnd - timerStart
	objectContainer.clear()
	rng.seed = 6
	_internalMPRTest(CCDSphere, CCDCylinder, numObjects, outParam, true)
	numCollisions2 = outParam["result"]
	timerEnd2 = OS.get_ticks_msec()
	timeTotal2 = timerEnd2 - timerEnd
	bbCode = "[center]{0}ms ({1})\n{2}ms ({3})[/center]".format([timeTotal, numCollisions, timeTotal2, numCollisions2])
	$VBoxContainer/HBoxContainer5/lblInfoSC.bbcode_text = bbCode
	yield(get_tree(), "idle_frame")
	
	# Done
	isDoingTest = false

# Internal test for Godot's area type
func _internalAreaTest(originalArea :Area, originalArea2 :Area, numObjects :int, preAdd :bool, outParam :Dictionary):
	var numCollisions :int = 0
	
	# Add the first area
	var area :Area = originalArea.duplicate()
	area.translation = Vector3(rng.randf_range(0.0, objectRange), 0.0, rng.randf_range(0.0, objectRange))
	area.rotation = Vector3(deg2rad(rng.randf_range(0.0, 180.0)), 0.0, deg2rad(rng.randf_range(0.0, 180.0)))
	add_child(area)
	objectContainer.push_back(area)
	
	# Add the rest of the areas and check for collision with the rest
	for i in range(0, numObjects-1):
		# Add area
		if i % 2 == 1 && originalArea2 != null:
			area = originalArea2.duplicate()
		else:
			area = originalArea.duplicate()
		area.translation = Vector3(rng.randf_range(0.0, objectRange), 0.0, rng.randf_range(0.0, objectRange))
		area.rotation = Vector3(deg2rad(rng.randf_range(0.0, 180.0)), 0.0, deg2rad(rng.randf_range(0.0, 180.0)))
		add_child(area)
		
		if preAdd == false:
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
	
	# In preAdd scenario, check all collisions at once 
	if preAdd:
		yield(get_tree(), "physics_frame")
		yield(get_tree(), "physics_frame")
		yield(get_tree(), "physics_frame")
		
		for area2 in objectContainer:
			for otherArea in objectContainer:
				if area2 == otherArea:
					continue
				
				var collides :bool = area2.overlaps_area(otherArea)
				if collides:
					numCollisions += 1
					break
	
	# Done
	outParam["result"] = numCollisions

# Clear the object container and remove the objects from the scene
func _clearObjectsArea():
	for area in objectContainer:
		remove_child(area)
	objectContainer.clear()

# Internal test for godotccd GJK type
func _internalGJKTest(originalType :NativeScript, originalType2 :NativeScript, numObjects :int, outParam :Dictionary, withInfo :bool = false):
	var numCollisions :int = 0
	
	# Add the first shape (just use identity as rotation as we don't rotate in this test)
	var position :Vector3 = Vector3(rng.randf_range(0.0, objectRange), 0.0, rng.randf_range(0.0, objectRange))
	var rotation :Quat = Quat.IDENTITY
	rotation.set_euler(Vector3(deg2rad(rng.randf_range(0.0, 180.0)), 0.0, deg2rad(rng.randf_range(0.0, 180.0))))
	var dimensions :Vector3 = Vector3(1.0, 1.0, 1.0)
	var shape = originalType.new();
	if originalType == CCDBox:
		shape.initialize(position, rotation, dimensions * 2)
	elif originalType == CCDSphere:
		shape.initialize(position, rotation, dimensions.x)
	else:
		shape.initialize(position, rotation, dimensions.x, dimensions.y * 2)
	objectContainer.push_back(shape)
	
	# Add the rest of the shapes and check for collision with the rest
	var chosenType = null
	for i in range(0, numObjects-1):
		# Add shape
		if i % 2 == 1 && originalType2 != null:
			shape = originalType2.new()
			chosenType = originalType2
		else:
			shape = originalType.new()
			chosenType = originalType
		
		# Initialize shape
		position = Vector3(rng.randf_range(0.0, objectRange), 0.0, rng.randf_range(0.0, objectRange))
		rotation.set_euler(Vector3(deg2rad(rng.randf_range(0.0, 180.0)), 0.0, deg2rad(rng.randf_range(0.0, 180.0))))
		if chosenType == CCDBox:
			shape.initialize(position, rotation, dimensions * 2)
		elif chosenType == CCDSphere:
			shape.initialize(position, rotation, dimensions.x)
		else:
			shape.initialize(position, rotation, dimensions.x, dimensions.y * 2)
		
		# Check collision with the existing shapes until a collision happens
		for other in objectContainer:
			var collides :bool = false
			if withInfo == false:
				collides = shape.collidesWithGJK(other)
			else:
				var collisionInfo :Dictionary = {}
				collides = shape.collidesWithGJKAndInfo(other, collisionInfo)
			if collides:
				numCollisions += 1
				break
		objectContainer.push_back(shape)
		
	# Done
	outParam["result"] = numCollisions

# Internal test for godotccd MPR type
func _internalMPRTest(originalType :NativeScript, originalType2 :NativeScript, numObjects :int, outParam :Dictionary, withInfo :bool = false):
	var numCollisions :int = 0
	
	# Add the first shape (just use identity matrix as rotation as we don't rotate in this test)
	var position :Vector3 = Vector3(rng.randf_range(0.0, objectRange), 0.0, rng.randf_range(0.0, objectRange))
	var rotation :Quat = Quat.IDENTITY
	rotation.set_euler(Vector3(deg2rad(rng.randf_range(0.0, 180.0)), 0.0, deg2rad(rng.randf_range(0.0, 180.0))))
	var dimensions :Vector3 = Vector3(1.0, 1.0, 1.0)
	var shape = originalType.new();
	if originalType == CCDBox:
		shape.initialize(position, rotation, dimensions * 2)
	elif originalType == CCDSphere:
		shape.initialize(position, rotation, dimensions.x)
	else:
		shape.initialize(position, rotation, dimensions.x, dimensions.y * 2)
	objectContainer.push_back(shape)
	
	# Add the rest of the shapes and check for collision with the rest
	var chosenType = null
	for i in range(0, numObjects-1):
		# Add shape
		if i % 2 == 1 && originalType2 != null:
			shape = originalType2.new()
			chosenType = originalType2
		else:
			shape = originalType.new()
			chosenType = originalType
		
		# Initialize shape
		position = Vector3(rng.randf_range(0.0, objectRange), 0.0, rng.randf_range(0.0, objectRange))
		rotation.set_euler(Vector3(deg2rad(rng.randf_range(0.0, 180.0)), 0.0, deg2rad(rng.randf_range(0.0, 180.0))))
		if chosenType == CCDBox:
			shape.initialize(position, rotation, dimensions * 2)
		elif chosenType == CCDSphere:
			shape.initialize(position, rotation, dimensions.x)
		else:
			shape.initialize(position, rotation, dimensions.x, dimensions.y * 2)
		
		# Check collision with the existing shapes until a collision happens
		for other in objectContainer:
			var collides :bool
			if withInfo == false:
				collides = shape.collidesWithMPR(other)
			else:
				var collisionInfo :Dictionary = {}
				collides = shape.collidesWithMPRAndInfo(other, collisionInfo)
			if collides:
				numCollisions += 1
				break
		objectContainer.push_back(shape)
		
	# Done
	outParam["result"] = numCollisions
