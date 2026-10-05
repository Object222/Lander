class_name Thrust
extends Node3D

const CONE_IDLE: float = 0.3
const CONE_MAX: float = 1.0
const CONE_FLICKER: float = 0.08
const CONE_LERP: float = 12.0

const SPOT_IDLE: float = 1.0
const SPOT_MAX: float = 10.0
const SPOT_FLICKER: float = 0.12
const SPOT_LERP: float = 12.0

const SOUND_IDLE_DB: float = -20.0
const SOUND_MAX_DB: float = -2.0
const PITCH_IDLE: float = 0.8
const PITCH_MAX: float = 1.7
const SOUND_LERP: float = 6.7


@onready var cone: MeshInstance3D = $Cone
@onready var spot_light_3d: SpotLight3D = $SpotLight3D
@onready var thrust_sound: AudioStreamPlayer3D = $ThrustSound


func update(thrust_on: bool, delta: float) -> void:
	update_cone(thrust_on, delta)
	update_spot(thrust_on, delta)
	update_thrust_sound(thrust_on, delta)

func _ready() -> void:
	cone.scale = CONE_IDLE * Vector3.ONE
	thrust_sound.volume_db = SOUND_IDLE_DB

func update_thrust_sound(thrust_on: bool, delta: float) -> void:
	var target_volume: float = SOUND_IDLE_DB
	var target_pitch: float = PITCH_IDLE
	if thrust_on:
		target_volume = SOUND_MAX_DB
		target_pitch = PITCH_MAX
	thrust_sound.volume_db = lerpf(thrust_sound.volume_db, target_volume, SOUND_LERP * delta)
	thrust_sound.pitch_scale = lerpf(thrust_sound.pitch_scale, target_pitch, SOUND_LERP * delta)
	


func update_cone(thrust_on: bool, delta: float) -> void:
	var target_scale: float = CONE_IDLE
	if thrust_on:
		target_scale = CONE_MAX + randf_range(-CONE_FLICKER, CONE_FLICKER)
	cone.scale = cone.scale.lerp(target_scale * Vector3.ONE, delta * CONE_LERP)

func update_spot(thrust_on: bool, delta: float) -> void:
	var target_energy: float = SPOT_IDLE
	if thrust_on:
		target_energy = SPOT_MAX + randf_range(-SPOT_FLICKER, SPOT_FLICKER)
	spot_light_3d.light_energy = lerpf(spot_light_3d.light_energy, target_energy, delta * SPOT_LERP)

func turn_off() -> void:
	thrust_sound.stop()
	spot_light_3d.visible = false
	cone.scale = CONE_IDLE * Vector3.ONE
