extends Control

enum CustomMouseMode {FROZEN, CENTERED, FREE}

var mouseMode : CustomMouseMode = CustomMouseMode.FREE
var osMouseVisible = true
var osMouseShouldBeConfined = false
var fakeMousePos = Vector2.ZERO

@onready var CursorImage = $Cursor

func _input(event: InputEvent) -> void:
	if event.is_action("Drag Camera"):
		mouseMode = CustomMouseMode.FROZEN if event.is_pressed() else CustomMouseMode.FREE

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	match mouseMode:
		CustomMouseMode.FREE:
			fakeMousePos = get_viewport().get_mouse_position()
			
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN if not osMouseVisible else Input.MOUSE_MODE_VISIBLE
		CustomMouseMode.FROZEN:
			if Input.is_action_just_pressed("Drag Camera"):
				fakeMousePos = get_viewport().get_mouse_position()
			else:
				Input.warp_mouse(fakeMousePos)
			
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	CursorImage.position = fakeMousePos - CursorImage.size/2

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			osMouseVisible = false
			print("hiding")
		NOTIFICATION_MOUSE_EXIT:
			osMouseVisible = true
			print("showing")
