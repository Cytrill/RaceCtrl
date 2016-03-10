
extends Area2D

export var cp_number = 0;
export var finish_line = false
export var final_cp = 1

func _ready():
	connect("body_enter", self, "_on_body_enter")


func _on_body_enter(body):
	if ("Cars" in body.get_groups()):
		if body.last_checkpoint == cp_number-1:
			body.last_checkpoint = cp_number
			print("Checkpoint:"+str(body.last_checkpoint))
		if finish_line && body.last_checkpoint == final_cp :
			body.lap += 1
			body.last_checkpoint = cp_number
			print("Lap: " +str(body.lap))