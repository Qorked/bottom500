extends Label

@export var phrases: Array[String] = [
	"Don't Crash!",
	"Rest Stop Ahead!",
	"Wrong Way!",
	"You're doing great!",
	"Almost there!",
	"Careful now!",
	"Warning",
	"No Left Turns!",
	"Who Wrote This?",
	"Right Left Turns",
	"Only Reverse",
	"Pizza!"
]

func _ready():
	randomize()
	text = phrases.pick_random()
