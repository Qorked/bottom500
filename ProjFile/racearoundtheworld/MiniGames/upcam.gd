extends Camera2D

@export_node_path("Node2D") var target_path: NodePath
var target: Node2D
var highest_y := 0.0

func _ready():
	target = get_node(target_path)
	highest_y = target.global_position.y
	global_position = target.global_position

func _process(delta):
	if target and target.global_position.y < highest_y:
		highest_y = target.global_position.y
		global_position.y = highest_y  # only follow up
