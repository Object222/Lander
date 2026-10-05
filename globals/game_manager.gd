extends Node

const GAME = preload("res://scenes/game/game.tscn")
const MAIN = preload("res://scenes/main/main.tscn")

var high_score: int:
	get: return _score_data.high_score


var _score_data: ScoreData

func _ready() -> void:
	_score_data = ScoreData.load_or_create()

func submit_score(score: int) -> bool:
	return _score_data.submit(score)

func load_main() -> void:
	get_tree().change_scene_to_packed(MAIN)

func load_game() -> void:
	get_tree().change_scene_to_packed(GAME)
