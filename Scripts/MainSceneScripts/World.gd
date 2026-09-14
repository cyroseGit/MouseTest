extends Node3D

func addChar(id):
	var newChar : PlayerCharacter = load("res://Scenes/Classes/Character.tscn").instantiate()
		
	newChar.name = str(id) + "Character"
	newChar.set_multiplayer_authority(id)
		
	add_child(newChar)

func _ready() -> void:
	for player : Player in GameService.get_children():
		addChar(player.name.to_int())
	
	GameService.playerJoined.connect(func(player : Player):
		addChar(player.name.to_int())
	)
