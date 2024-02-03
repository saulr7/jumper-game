extends Node


func add_log_message(msg: String):
	var console = get_tree().get_first_node_in_group("debug_console")
	
	if not console:
		print("no console found")
		return
	
	var log_label = console.find_child("LogLabel")
	
	if not log_label:
		print("no log label found")
		return
		
	log_label.text += msg + "\n"
		
	
