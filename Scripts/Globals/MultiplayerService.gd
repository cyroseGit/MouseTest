extends Node

## custom signals

## variables

var targetIP = "localhost"
var targetPort = 5000

var isHosting = false

## functions

func openHost(port : int):
	var peer = ENetMultiplayerPeer.new()
	var _error = peer.create_server(port, 32)
	
	multiplayer.multiplayer_peer = peer
	isHosting = true
	
	GameService.playerJoining(1)
	GameService.startGame()

func connectToHost(address : String, port : int):
	var peer = ENetMultiplayerPeer.new()
	var _error = peer.create_client(address, port)
	
	multiplayer.multiplayer_peer = peer
	GameService.playerJoining(peer.get_unique_id())

## signal specific functions

func onSelfConnected():
	GameService.startGame()

func onPlayerConnected(playerId):
	GameService.playerJoining(playerId)

func onPlayerDisconnected(playerId):
	GameService.playerLeaving(playerId)

## signals

func _ready():
	multiplayer.peer_connected.connect(onPlayerConnected)
	multiplayer.peer_disconnected.connect(onPlayerDisconnected)
	multiplayer.connected_to_server.connect(onSelfConnected)
