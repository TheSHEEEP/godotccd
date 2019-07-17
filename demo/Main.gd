extends Spatial
const CCDSphere = preload("res://addons/godotccd/ccdSphere.gdns")

# Called when the node enters the scene tree for the first time.
func _ready():
	var sphere = CCDSphere.new()
	sphere.initialize(Vector3(1.1, 2.2, 3.3), 4.4)
	pass # Replace with function body.
