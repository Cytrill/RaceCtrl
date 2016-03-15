
extends Area2D

export var cp_number = 0;
export var finish_line = false
export var final_cp = 1
var current_lap = 1

func _ready():
	connect("body_enter", self, "_on_body_enter")

func calc_positions():
	var car_array = []
	
	for car in get_node("/root/World").get_children():
		if "Cars" in car.get_groups():
			car.calc_score()
			car_array.append(car)
	car_array.sort_custom(self, "score_comparator")
	var lbPos = get_node("/root/World/GUI/Positions")
	lbPos.set_text(str(get_node("/root/World/Goal").current_lap)+"\n")

	for i in range(0, car_array.size() ):
		car_array[i].place = (i+1)
		lbPos.set_text(lbPos.get_text() + "\n" + str(car_array[i].place)+". P"+str(car_array[i].player_number) )

func score_comparator(a, b):
	if (a.score > b.score):
		return true
	else:
		return false

func _on_body_enter(body):
	if ("Cars" in body.get_groups()):
		if body.last_checkpoint == cp_number-1 && !body.race_over:
			#print("BEFORE: Lap: "+str(body.lap)+", Checkpoint:"+str(body.last_checkpoint) + ", Time: " + str(body.last_checkpoint_time))
			body.last_checkpoint = cp_number
			body.last_checkpoint_time = get_node("/root/World").time_elapsed
			#print("AFTER Lap: "+str(body.lap)+", Checkpoint:"+str(body.last_checkpoint) + ", Time: " + str(body.last_checkpoint_time))
			calc_positions()
		if finish_line && body.last_checkpoint == final_cp :
			if (body.lap < get_node("/root/World").number_of_laps):
				body.lap += 1
				if (body.lap > current_lap):
					current_lap = body.lap
				body.last_checkpoint = cp_number
				calc_positions()
				body.last_checkpoint_time = get_node("/root/World").time_elapsed
			else:
				body.race_over = true