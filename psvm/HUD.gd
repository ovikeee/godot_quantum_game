extends CanvasLayer

var playerDebug: String
var mainDebug: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _process(delta):
	$DebugLabel.text = ""
	$DebugLabel.text += playerDebug + "\n"
	$DebugLabel.text += mainDebug + "\n"

func display_player_debug(var debugText):
	playerDebug = debugText
	
func display_main_debug(var debugText):
	mainDebug = debugText