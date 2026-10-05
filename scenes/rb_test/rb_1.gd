extends RigidBody3D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		freeze = !freeze


func _on_sleeping_state_changed() -> void:
	pass # Replace with function body.
