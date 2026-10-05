class_name ScoreData

extends Resource


const SAVE_PATH: String = "user://lander_score.tres"

@export var high_score: int = 0

func submit(score: int) -> bool:
	if score <= high_score: return false
	high_score = score
	ResourceSaver.save(self, SAVE_PATH)
	return true


static func load_or_create() -> ScoreData:
	if ResourceLoader.exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH) as ScoreData
	return ScoreData.new()
