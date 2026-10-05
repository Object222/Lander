class_name RocketTelemetry

extends RefCounted


var speed: float = 0.0
var vert_speed: float = 0.0
var distance: float = 0.0
var height_delta: float = 0.0
var tilt: float = 0.0
var spin: = 0.0
var fuel: = 0.0

func _to_string() -> String:
	var s: String = "Speed:    %5.1f m/s\nVertical:    %5.1f \n" % [speed, vert_speed]
	s += "Distance:    %5.1f m\nHeight:    %5.1f m\n" % [distance, height_delta]
	s += "Tilt:    %5.0f°\nSpin    %5.0f rad/s\n" % [tilt, spin]
	s += "Fuel:    %.0fL" % [fuel * 1000]
	return s
