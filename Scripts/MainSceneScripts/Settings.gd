extends Control



func _on_sensitivity_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		GameService.Settings.Sensitivity = new_text.to_float()
