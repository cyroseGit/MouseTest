extends Control

## custom signals/enums

enum CustomMouseMode {FROZEN, CENTERED, FREE}

signal mouseMoved

## vars

var mouseMode : CustomMouseMode = CustomMouseMode.FREE
var fakeMousePos = Vector2.ZERO

var warpTo = Vector2.ZERO
var wasFrozen = 0
var osMouseVisible = true
var ignoreNextMouseInput = false
var osMouseShouldBeConfined = false

@onready var CursorImage = $Cursor

## functions

## connections

func _input(event: InputEvent) -> void:
	if event.is_action("Drag Camera"):
		mouseMode = CustomMouseMode.FROZEN if event.is_pressed() else CustomMouseMode.FREE
		
		if not event.is_pressed():
			wasFrozen = 2
	elif event is InputEventMouseMotion:
		mouseMoved.emit(Vector2(event.screen_relative.x, event.screen_relative.y))
		
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED && mouseMode != CustomMouseMode.FROZEN:
			fakeMousePos += Vector2(event.screen_relative.x, event.screen_relative.y)

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	match mouseMode:
		CustomMouseMode.FREE:
			if wasFrozen > 0:
				get_viewport().warp_mouse(fakeMousePos)
				wasFrozen -= 1
			else:
				fakeMousePos = get_viewport().get_mouse_position()
			
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN if not osMouseVisible else Input.MOUSE_MODE_VISIBLE
		CustomMouseMode.FROZEN:
			if Input.is_action_just_pressed("Drag Camera"):
				fakeMousePos = get_viewport().get_mouse_position()
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	CursorImage.position = fakeMousePos - CursorImage.size/2

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			osMouseVisible = false
			print("hiding")
		NOTIFICATION_MOUSE_EXIT:
			osMouseVisible = true
			print("showing")
