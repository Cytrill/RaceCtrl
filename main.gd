
extends Node2D

var time_elapsed = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	time_elapsed += delta
	get_node("Skidmarks").set_texture(get_node("Viewport").get_render_target_texture())
	




func _on_raiseZIndex_body_enter( body ):
	pass # replace with function body


func _on_RaiseZIndex_body_enter( body ):
	pass # replace with function body
