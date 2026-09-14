extends CharacterBody3D
class_name PlayerCharacter

## custom signals

## variables

@export var moveDirection : Vector3
@export var walkSpeed : float = 16
@export var jumpPower : float = 50
@export var grounded : bool = false

@export_range(0,100,1) var Health : float = 100

@onready var animTree = $AnimationTree
@onready var Camera = $CameraOrigin/Camera3D
@onready var CameraOrigin = $CameraOrigin
@onready var CharacterModel : Node3D = $Character

var currentScroll = 10.0
var EffectiveScroll = 10.0
var cameraAngles = Vector2(deg_to_rad(15),deg_to_rad(0))
var maxCamAngle = deg_to_rad(85)

var Gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

## functions

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event.is_action("Zoom In") || event.is_action("Zoom Out"):
			if event.is_action("Zoom In"):
				currentScroll = max(5.0, currentScroll - 5.0)
			else:
				currentScroll += 5.0

func HandleMouseInput(MouseVectors : Vector2):
	if is_multiplayer_authority() && VirtualCursor.mouseMode == VirtualCursor.CustomMouseMode.FROZEN:
		cameraAngles.x -= deg_to_rad(MouseVectors.y) * GameService.Settings.Sensitivity
		cameraAngles.y -= deg_to_rad(MouseVectors.x) * GameService.Settings.Sensitivity
		
		cameraAngles.x = clamp(cameraAngles.x, -maxCamAngle, maxCamAngle)

## signals

func _process(dt : float) -> void:
	var walkBlend = animTree.get("parameters/WalkProgress/blend_amount")
	var airBlend = animTree.get("parameters/JumpProgress/blend_amount")
	
	if moveDirection.length() > 0:
		var targetBasis = Basis.looking_at(moveDirection.normalized(), Vector3.UP)
		
		CharacterModel.basis = CharacterModel.basis.slerp(targetBasis, dt * 15)
	
	animTree.set("parameters/WalkProgress/blend_amount", clamp(walkBlend + (dt if moveDirection.length() > 0 else -dt)*5, 0, 1))
	animTree.set("parameters/JumpProgress/blend_amount", clamp(airBlend + (dt if not grounded else -dt)*5, 0, 1))
	
	if is_multiplayer_authority():
		Camera.current = true
		
		Camera.global_basis = Basis.from_euler(Vector3(cameraAngles.x, cameraAngles.y, 0))
		Camera.global_position = CameraOrigin.global_position + Camera.transform.basis.z * EffectiveScroll
		
		EffectiveScroll = lerp(EffectiveScroll, currentScroll, dt * 16)

func _physics_process(dt : float) -> void:
	var MoveVector = moveDirection
	var oldVelo = velocity
	
	if is_multiplayer_authority():
		var desiredVector = Input.get_vector("Move Left", "Move Right", "Move Forwards", "Move Backwards")
		MoveVector = Vector3(desiredVector.x, 0, desiredVector.y)
		
		if not is_on_floor():
			oldVelo.y -= Gravity * dt
		elif Input.is_action_pressed("Jump") && is_multiplayer_authority():
			oldVelo.y += jumpPower
		
		grounded = is_on_floor()
	
	moveDirection = MoveVector.rotated(Vector3.UP, cameraAngles.y)
	
	velocity = moveDirection*walkSpeed + (oldVelo * Vector3.UP)
	move_and_slide()

func _ready():
	if is_multiplayer_authority():
		VirtualCursor.mouseMoved.connect(HandleMouseInput)
