extends Camera3D

const OFFSET: Vector3 = Vector3(0, 6, 10)
const FOLLOW_SPEED: float = 3.0


@export var rocket: Node3D
@export var pad: Node3D

var _last_dir: Vector3 = Vector3.BACK

func _ready() -> void:
	if rocket and pad:
		global_position = get_desired_position()
		look_at(rocket.global_position)

func _physics_process(delta: float) -> void:
	if rocket == null or pad == null: return
	global_position = global_position.lerp(get_desired_position(), delta * FOLLOW_SPEED)
	look_at(rocket.global_position)

func get_desired_position() -> Vector3:
	var to_rocket: Vector3 = rocket.global_position - pad.global_position
	to_rocket.y = 0
	if to_rocket.length() > 1.0:
		_last_dir = to_rocket.normalized()
	return rocket.global_position + _last_dir * OFFSET.z + Vector3.UP * OFFSET.y
	
