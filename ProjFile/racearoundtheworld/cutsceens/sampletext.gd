extends Label

@export var phrases: Array[String] = [
	"Don't Crash!",
	"Rest Stop Ahead!",
	"Wrong Way!",
	"You're doing great!",
	"Almost there!",
	"Careful now!",
	"Warning",
	"Fast Fast Fast",
	"Who Wrote This?",
	"Right Left Turns",
	"Only Reverse",
	"Pizza!",
	"Donut Crash!",
	"Rest Ahead Stop!",
	"Road Sign!",
	"Battle Royal!",
	"Just Jump!",
	"Why?",
	"Are we there yet?",
	"Two And Four",
	"Let me win already.",
	"Hello World",
	"Must be a Bug",
	"Flavor Sign!"
]

func _ready():
	randomize()
	text = phrases.pick_random()
