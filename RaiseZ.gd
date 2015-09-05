
extends Area2D

export var z_level = 0

func _ready():
	connect("body_enter", self, "_on_body_enter")


func _on_body_enter(body):
	if ("Cars" in body.get_groups()):
		body.set_z(z_level)
		if (z_level > 0):
			body.set_collision_mask_bit(2,true)
			body.set_collision_mask_bit(1,false)
			print("Z-UP" + str(body.get_collision_mask()))
		else:
			body.set_collision_mask_bit(2,false)
			body.set_collision_mask_bit(1,true)
			print("Z-DOWN" + str(body.get_collision_mask()))

