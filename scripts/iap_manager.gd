extends Node

signal unlocked_new_skin


func purchase_skin():
	unlocked_new_skin.emit()
	



