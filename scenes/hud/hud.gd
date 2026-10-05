extends Control

@onready var label: Label = $MC/Label
@onready var game_over_rect: ColorRect = $GameOverRect
@onready var timer: Timer = $Timer
@onready var result_label: Label = $GameOverRect/ResultLabel
@onready var crash_sound: AudioStreamPlayer = $CrashSound
@onready var land_sound: AudioStreamPlayer = $LandSound
@onready var music: AudioStreamPlayer = $Music




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameManager.load_main()

func _ready() -> void:
	SignalHub.telemetry_updated.connect(on_emit_telemetry_updated)
	SignalHub.game_over.connect(on_emit_game_over)

func on_emit_telemetry_updated(telemetry: RocketTelemetry) -> void:
	label.text = str(telemetry)

func on_emit_game_over(result: LandingResult) -> void:
	music.volume_db -= 20.0
	match result.outcome:
		LandingResult.Outcome.LANDED:
			result_label.text = "LANDED - Score: %d" % result.score
			if result.new_high_score: result_label.text += "NEW BEST!!!"
			land_sound.play(23.0)
		LandingResult.Outcome.CRASHED:
			result_label.text = "CRASHED"
			crash_sound.play()
		LandingResult.Outcome.LOST:
			result_label.text = "LOST"
			crash_sound.play()
	game_over_rect.show()
	timer.start()


func _on_timer_timeout() -> void:
	get_tree().paused = true
