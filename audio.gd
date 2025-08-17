extends AudioStreamPlayer2D

var cache: Dictionary[String,AudioStream] = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.PlaySound.connect(play_sound)

func play_sound(sound:String,location:Vector2):
	if sound not in cache:
		cache[sound] = load("res://Sounds/%s.wav" % [sound])
	
	stream = cache[sound]
	
	position = location
	play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
