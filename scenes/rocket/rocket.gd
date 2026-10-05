extends RigidBody3D

const THRUST_FORCE: float = 15.0
const SIDE_THRUST_FORCE: float = 3.0
const TORQUE_STRENGTH: float = 2.0
const MAX_LANDING_SPEED: float = 5.0
const MAX_LANDING_TILT: float = 10.0
const MAX_FUEL: float = 100.0
const FUEL_DROP: float = 50.0
const MAX_DISTANCE: float = 6.0



@export var landing_pad: Node3D
@export var wind: Wind


@onready var thrust: Thrust = $Thrust
@onready var thrust_l: Thrust = $ThrustL
@onready var thrust_r: Thrust = $ThrustR
@onready var timer: Timer = $Timer

var _last_speed: float = 0.0
var _fuel: float = 100.0
var _out_of_fuel: bool = false
var _fuel_out_y: float = 0.0

func _physics_process(delta: float) -> void:
	if wind and get_contact_count() == 0:
		apply_central_force(wind.wind_force)
	if !_out_of_fuel:
		apply_main_thrust(delta)
		apply_side_thrusters(delta)
		apply_rotation()
	
	emit_telemetry()
	check_fuel()
	
	_last_speed = linear_velocity.length()

func apply_rotation() -> void:
	var pitch: float = Input.get_axis("pitch_down", "pitch_up")
	var yaw: float = Input.get_axis("yaw_left", "yaw_right")
	
	var torque: Vector3 = global_transform.basis.x * pitch * TORQUE_STRENGTH
	torque += global_transform.basis.y * yaw * TORQUE_STRENGTH
	
	apply_torque(torque)

func apply_main_thrust(delta: float) -> void:
	var thrust_applied: bool = Input.is_action_pressed("thrust")
	if thrust_applied:
		_fuel -= delta
		apply_central_force(global_transform.basis.y * THRUST_FORCE)
	
	thrust.update(thrust_applied, delta)

func apply_side_thrusters(delta: float) -> void:
	var thrust_left_applied: bool = Input.is_action_pressed("roll_left")
	var thrust_right_applied: bool = Input.is_action_pressed("roll_right")
	
	if thrust_left_applied: 
		apply_side_thrust(thrust_l, delta)
	if thrust_right_applied: 
		apply_side_thrust(thrust_r, delta)
	
	thrust_l.update(thrust_left_applied, delta)
	thrust_r.update(thrust_right_applied, delta)

func apply_side_thrust(thruster: Thrust, delta: float) -> void:
	_fuel -= delta / 3
	var offset: Vector3 = thruster.global_position - global_position
	apply_force(global_transform.basis.y * SIDE_THRUST_FORCE, offset)

func check_fuel() -> void:
	if !_out_of_fuel and _fuel <= 0.0:
		_out_of_fuel = true
		_fuel = 0.0
		_fuel_out_y = global_position.y
		thrust.turn_off()
		thrust_l.turn_off()
		thrust_r.turn_off()
		
		
	if _out_of_fuel and global_position.y < _fuel_out_y - FUEL_DROP:
		game_over(LandingResult.Outcome.LOST)
		freeze = true

func calculate_score() -> int:
	var fuel_score: int = int((_fuel / MAX_FUEL) * 1000)
	var dist: float = global_position.distance_to(landing_pad.global_position)
	var dist_score: int = int(clampf(1.0 - dist / MAX_DISTANCE, 0.0, 1.0) * 1000)
	return fuel_score + dist_score

func get_tilt() -> float:
	return rad_to_deg(global_transform.basis.y.angle_to(Vector3.UP))

func emit_telemetry() -> void:
	var tel: RocketTelemetry = RocketTelemetry.new()
	tel.speed = linear_velocity.length()
	tel.vert_speed = linear_velocity.y
	tel.tilt = get_tilt()
	tel.spin = angular_velocity. length()
	tel.fuel = _fuel
	if landing_pad:
		tel.distance = global_position.distance_to(landing_pad.global_position)
		tel.height_delta = global_position.y - landing_pad.global_position.y
	SignalHub.emit_telemetry(tel)
	

func game_over(outcome: LandingResult.Outcome) -> void:
	set_physics_process(false)
	var res: LandingResult = LandingResult.new()
	res.outcome = outcome
	if res.outcome == LandingResult.Outcome. LANDED:
		res.score = calculate_score()
		res.new_high_score = GameManager.submit_score(res.score)
		res.high_score = GameManager.high_score
	SignalHub.emit_game_over(res)

func _on_body_entered(_body: Node) -> void:
	if _last_speed > MAX_LANDING_SPEED:
		print("CRASHED")
		timer.start()
		game_over(LandingResult.Outcome.CRASHED)


func _on_sleeping_state_changed() -> void:
	if sleeping:
		if is_physics_processing():
			if get_tilt() < MAX_LANDING_TILT:
				game_over(LandingResult.Outcome.LANDED)
			else:
				game_over(LandingResult.Outcome.CRASHED)


func _on_timer_timeout() -> void:
	freeze = true
