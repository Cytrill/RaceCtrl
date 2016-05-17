
extends Node2D

var time_elapsed = 0
var spawn_time = 100
export var number_of_laps = 3

#Player Colors
const colarray = [Color(0, 0, 1), Color(0, 1, 0), Color(0, 1, 1),
	Color(1, 0, 0), Color(1, 0, 1), Color(1, 1, 0), Color(1, 1, 1), Color(0, 0, 0)]

const player_preload = preload("player.scn")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	time_elapsed += delta
	
	game_state_prev = game_state
	game_state = game_state_next
	
	if (game_state == "running"):
		state_running(delta)
	
	if (game_state == "timeup"):
		state_timeup(delta)
	
	get_node("Skidmarks").set_texture(get_node("Viewport").get_render_target_texture())
	
	

var game_time = 120 #In Seconds
var timeout_time = 20 #In Seconds
var time_remaining = game_time

var game_state_prev = ""
var game_state = ""
var game_state_next = "timeup"

var fight_dialog_time = 10 #In Seconds
var last_player_number = 0
var countdown_started = false

func state_running(delta):
	if (game_state_prev != "running"):
		time_elapsed = 0 #Reset Timer
		#Activate Ships:
		for car in get_node("/root/World").get_children():
			if "Cars" in car.get_groups():
				car.player_controlled = true
		
		
	
	time_remaining = game_time - time_elapsed
	
	if (time_elapsed > fight_dialog_time):
		pass#get_node("HUD/LGo").hide()
	
	if (time_remaining <= 0):
		game_state_next = "timeup"
	else:
		var m = floor(time_remaining / 60)
		var s = (int(floor(time_remaining)) % 60)
		
		get_node("GUI/Timer").set_text(str(m) + ":" + str(s))
	
func state_timeup(delta):
	#Just entering timeup state:
	if (game_state_prev != "timeup"):
		last_player_number = 0
		time_elapsed = 0 #Reset Timer
		
		#Remove all Players
		"""
		for player in get_node("Players").get_children():
			player.queue_free()
		"""
		
	#Start countdown after two Players have joined the game:
	if (last_player_number > 1):
		if (!countdown_started):
			time_elapsed = 0
			countdown_started = true
		time_remaining = timeout_time - time_elapsed
	else:
		time_remaining = timeout_time
	
	if (time_remaining <= 0):
		game_state_next = "running"
		get_node("GUI/Timer").hide()
	else:
		var m = floor(time_remaining / 60)
		var s = (int(floor(time_remaining)) % 60)
		
		get_node("GUI/Timer").set_text(str(m) + ":" + str(s))
		
		
	#Check if a Player wants to join the game:
	for i in range(0,1024):
		if Input.is_joy_button_pressed(i, 0):
			var exists = false
			for child in get_node("/root/World").get_children():
				if "Cars" in child.get_groups():
					if child.player_number == i:
						exists = true
			if !exists:
				var new_player = player_preload.instance()
				new_player.player_number = i
				new_player.player_name = cytrill.get_name(i)
				new_player.set_pos(get_node("Goal").get_pos())
				var sprite =new_player.get_node("Sprite")
				var height = sprite.get_texture().get_height() * sprite.get_scale().y + 10
				var width = sprite.get_texture().get_width() * sprite.get_scale().x + 20
				var x = new_player.get_pos().x + last_player_number/2*height
				var y = new_player.get_pos().y -30 + width*(last_player_number%2)
				var even = last_player_number%2
				new_player.set_pos(Vector2( x , y))
				sprite.set_modulate(colarray[i%8])
				new_player.colorA = colarray[i%8]
				cytrill.set_led(i, 0, colarray[i%8].r*255, colarray[i%8].g*255, colarray[i%8].b*255, 2)
				cytrill.set_led(i, 1, colarray[i%8].r*255, colarray[i%8].g*255, colarray[i%8].b*255, 2)
				get_node("/root/World").add_child(new_player)
				last_player_number+=1
	
