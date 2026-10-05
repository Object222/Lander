extends Node


signal telemetry_updated(telemetry: RocketTelemetry)
signal game_over(result: LandingResult)

func emit_telemetry(telemetry: RocketTelemetry) -> void:
	telemetry_updated.emit(telemetry)

func emit_game_over(result: LandingResult) -> void:
	game_over.emit(result)
