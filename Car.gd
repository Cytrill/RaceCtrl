
extends RigidBody2D

var nose_norm = vec2(0,0)
var accel = 60.0
var sun = null
var shadow = null
var sound_motor = 0
var sound_skid = -1
func _ready():
	
	add_to_group("Cars")
	sun = get_node("/root/World/Sun")
	shadow = get_node("Shadow")
	set_fixed_process(true)
	sound_motor = get_node("SamplePlayer2D").play("engine3")
	
	
	
func _fixed_process(delta):
	
	
	#print(str(get_linear_velocity().length()))
	nose_norm = vec2(get_node("Nose").get_global_pos().x - get_pos().x, get_node("Nose").get_global_pos().y - get_pos().y).normalized()
	if (Input.is_action_pressed(get_name() + "_Up")):
		accel = abs(accel)
		apply_impulse(vec2(0,0),nose_norm*accel)
	if (Input.is_action_pressed(get_name() + "_Down")):
		accel = -abs(accel)
		apply_impulse(vec2(0,0),nose_norm*accel)
	print(get_linear_velocity().length())
	get_node("SamplePlayer2D").set_param(SamplePlayer2D.PARAM_PITCH_SCALE, .75 + get_linear_velocity().length()/170)
	
	if (abs(get_linear_velocity().angle_to(nose_norm)) > 0.5 && get_linear_velocity().length() > 150):
		var skidmark = get_node("/root/World/Viewport/Skidmark")
		skidmark.set_pos(get_pos())
		skidmark.set_rot(get_rot())
		skidmark.show()
		if (sound_skid == -1):
			 sound_skid = get_node("SampleSkid").play("skid")
		elif (!get_node("SampleSkid").is_voice_active(sound_skid)):
			#get_node("SampleSkid").stop_voice(sound_skid)
			sound_skid = get_node("SampleSkid").play("skid")
			
		
		
	if (Input.is_action_pressed(get_name() + "_Left")):
			set_rot(get_rot()+ min (.015*get_linear_velocity().length()*delta, 0.05) * (accel/abs(accel)))
			#set_rot(get_rot()+1*delta)
			
	if (Input.is_action_pressed(get_name() + "_Right")):
			set_rot(get_rot()- min (.015*get_linear_velocity().length()*delta, 0.05)* (accel/abs(accel))) 
			#set_rot(get_rot()-1*delta)
			
	
	shadow.set_offset(vec2(10,20).rotated(-get_rot()))
	
func _integrate_forces(state):
	if (state.get_contact_count() > 0):
		print("KOLLISION")
		

