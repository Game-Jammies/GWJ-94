## A scheduled event with a specified type that happens at a specific in-game time.
class_name Event

## A type of scheduled event that can happen during the game.
enum Type { DARKEN, MUTATE, TIME_UP }

var type: Type
var date: float

func _init(_type: Type, _date: float):
	type = _type
	date = _date

func _to_string() -> String:
	return "Event[type=%s, date=%f]" % [type, date]
