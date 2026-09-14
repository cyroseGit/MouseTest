extends Node3D

## signals/enums

## vars

@onready var CameraPoint : Node3D = $Map/CameraPoint
@onready var MenuUI : Control = $MainMenu

@onready var JoinAddress : LineEdit = $MainMenu/Panel/MarginContainer/VBoxContainer/Joining/JoinAddress
@onready var JoinPort : LineEdit = $MainMenu/Panel/MarginContainer/VBoxContainer/Joining/JoinPort
@onready var HostPort : LineEdit = $MainMenu/Panel/MarginContainer/VBoxContainer/HostPort
@onready var HostButton : Button = $MainMenu/Panel/MarginContainer/VBoxContainer/Buttons/Host
@onready var JoinButton : Button = $MainMenu/Panel/MarginContainer/VBoxContainer/Buttons/Join

## functions



## connections

func _process(dt : float) -> void:
	CameraPoint.rotation.y += dt/2

func _ready() -> void:
	HostButton.pressed.connect(func():
		if HostPort.text.is_empty(): HostPort.text = "5000"
		
		MenuUI.visible = false
		
		MultiplayerService.openHost(HostPort.text.to_int())
	)
	
	JoinButton.pressed.connect(func():
		if JoinAddress.text.is_empty(): JoinAddress.text = "localhost"
		if JoinPort.text.is_empty(): JoinPort.text = "5000"
		
		MenuUI.visible = false
		
		MultiplayerService.connectToHost(JoinAddress.text, JoinPort.text.to_int())
	)
