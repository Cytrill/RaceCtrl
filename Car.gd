
extends RigidBody2D

var nose_norm = vec2(0,0)
var accel = 26.0
 
func _ready():
	set_fixed_process(true)
	add_to_group("Cars")
	
	
func _fixed_process(delta):
	#print(str(get_linear_velocity().length()))
	nose_norm = vec2(get_node("Nose").get_global_pos().x - get_pos().x, get_node("Nose").get_global_pos().y - get_pos().y).normalized()
	if (Input.is_action_pressed(get_name() + "_Up")):
		apply_impulse(vec2(0,0),nose_norm*accel)
	if (Input.is_action_pressed(get_name() + "_Down")):
		apply_impulse(vec2(0,0),nose_norm*-accel)
	
	if (abs(get_linear_velocity().angle_to(nose_norm)) > 0.5):
		var skidmark = get_node("/root/World/Viewport/Skidmark")
		skidmark.set_pos(get_pos())
		skidmark.set_rot(get_rot())
		skidmark.show()
		
		
	if (Input.is_action_pressed(get_name() + "_Left")):
			set_rot(get_rot()+ min (.01*get_linear_velocity().length()*delta, 0.2))
	if (Input.is_action_pressed(get_name() + "_Right")):
			set_rot(get_rot()- min (.01*get_linear_velocity().length()*delta, 0.2))
	
func _integrate_forces(state):
	if (state.get_contact_count() > 0):
		print("KOLLISION")
		

