
extends Area2D

export var cp_number = 0;
export var finish_line = false
export var final_cp = 1

func _ready():
	connect("body_enter", self, "_on_body_enter")

func calc_positions():
	var car_array = []
	
	for car in get_node("/root/World").get_children():
		if "Cars" in car.get_groups():
			car.calc_score()
			print(car.score)
			car_array.append(car)
			
	
	
	for index in range(1,car_array.size()):
		var currentvalue = car_array[index]
		var position = index
		while position>0 and car_array[position-1].score>currentvalue.score:
		    car_array[position]=car_array[position-1]
		    position = position-1
		
		car_array[position]=currentvalue	

	
	for i in range(car_array.size()-1):
    	var x = car_array[i]
	    var j = i - 1
	    while (j >= 0 and car_array[j].score > x.score):
	        car_array[j+1] = car_array[j]
	        j = j - 1
	    car_array[j+1] = x
	 	
	for i in range(car_array.size()-1):
		#print(str(i)+"=i, Place:" + str(car_array[i].place))
		car_array[i].place = (i+1)
	



func _on_body_enter(body):
	if ("Cars" in body.get_groups()):
		if body.last_checkpoint == cp_number-1:
			#print("BEFORE: Lap: "+str(body.lap)+", Checkpoint:"+str(body.last_checkpoint) + ", Time: " + str(body.last_checkpoint_time))
			body.last_checkpoint = cp_number
			body.last_checkpoint_time = get_node("/root/World").time_elapsed
			#print("AFTER Lap: "+str(body.lap)+", Checkpoint:"+str(body.last_checkpoint) + ", Time: " + str(body.last_checkpoint_time))
			calc_positions()
			print("Place: " +str(body.place))
		if finish_line && body.last_checkpoint == final_cp :
			body.lap += 1
			body.last_checkpoint = cp_number
			calc_positions()
			print("Lap: " +str(body.lap))
			print("Place: " +str(body.place))
			body.last_checkpoint_time = get_node("/root/World").time_elapsed