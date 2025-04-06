extends Camera2D

@export var player_path: NodePath
@export var vertical_offset: float = 100.0  # Player appears above center

var player: Node2D
var highest_y: float

func _ready():
	make_current()
	player = get_node_or_null(player_path)
	if player:
		highest_y = player.global_position.y - vertical_offset
		global_position.y = highest_y
	else:
		push_error("❌ Camera: Player not found!")

func _process(delta):
	if not player:
		return

	var target_y = player.global_position.y - vertical_offset
	if target_y < highest_y:
		highest_y = target_y
		global_position.y = highest_y
