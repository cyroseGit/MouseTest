extends Node

## custom signals

signal playerJoined
signal playerLeft

## variables

var localPlayer : Player
var Settings = {
	Sensitivity = 0.65
}

## functions

func getPlayerFromId(playerId : int) -> Player:
	return get_node(str(playerId))

func playerJoining(playerId : int):
	var thisPlayer = Player.new()
	
	if playerId == multiplayer.get_unique_id(): localPlayer = thisPlayer
	thisPlayer.name = str(playerId)
	
	add_child(thisPlayer)
	playerJoined.emit(thisPlayer)

func playerLeaving(playerId):
	var playerNode : Player = getPlayerFromId(playerId)
	
	playerLeft.emit(playerNode)
	
	playerNode.queue_free()

func startGame():
	get_tree().change_scene_to_file("res://Scenes/Core/World.tscn")

## connections

func _ready():
	pass
