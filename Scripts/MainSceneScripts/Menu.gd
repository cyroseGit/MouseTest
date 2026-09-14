extends Node3D

## signals/enums

## vars

@onready var CameraPoint = $Map/CameraPoint

## functions

## connections

func _process(dt : float) -> void:
	CameraPoint.rotation.y += dt/2
