class_name Wind

extends Node3D

const ANGLE_LIMIT: float = 20.0
const TURN_RATE: float = 1.0
const BASE_FORCE: float = 1.0

var wind_force: Vector3 = Vector3.ZERO

var _base_angle: float = 0.0
var _current_angle: float = 0.0

@onready var timer: Timer = $Timer


func _ready() -> void:
	_base_angle = randf_range(0, TAU)
	_current_angle = _base_angle
	rotation.y = _base_angle

func _physics_process(delta: float) -> void:
	rotation.y = lerp(rotation.y, _current_angle, delta * TURN_RATE)
	wind_force = transform.basis.z * BASE_FORCE

func _on_timer_timeout() -> void:
	_current_angle = _base_angle + deg_to_rad(randf_range(-ANGLE_LIMIT, ANGLE_LIMIT))
