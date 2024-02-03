extends TextureButton


class_name ScreenButton

signal clicked2(button)

func _on_pressed():
	clicked2.emit(self)
