extends Node3D

@export var start_grace_time = 45.0
@export var sys_stable_time = 15.0
@export var wave_time = 60.0
@export var break_time = 15.0

var elapsed_time = 0.0

var start_grace_time_remaining = 0.0
var sys_stable_time_remaining = 0.0
var wave_time_remaining = 0.0
var break_time_remaining = 0.0
var shutdown_time_remaining = 0.0

var shutdown_duration = 0.0
var shutdown_activated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_grace_time_remaining = start_grace_time
	sys_stable_time_remaining = sys_stable_time
	wave_time_remaining = wave_time
	break_time_remaining = break_time



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timers(delta)
	if shutdown_activated: shutdown_sequence(delta, shutdown_duration)


var last_stable_time = 0.0
var saved_current_time = false 
func timers(delta):
	elapsed_time += delta
	if start_grace_time_remaining > 0:	start_grace_time_remaining -= delta
	elif wave_time_remaining > 0:
		wave_time_remaining -= delta
		if sys_stable_time_remaining > 0:	sys_stable_time_remaining -= delta
		else:
			if not saved_current_time:
				last_stable_time = elapsed_time
				saved_current_time = true
			shutdown_randomizer(delta, last_stable_time)
	elif break_time_remaining > 0:	break_time_remaining -= delta


var s_r_flag = 0.0
func shutdown_randomizer(delta, last_stable_time):
	s_r_flag += delta
	if s_r_flag >= 1:
		if randf() <= 0.1 and not shutdown_activated: 
			shutdown_duration = 15 + randf_range(-7, 5)
			shutdown_activated = true
		s_r_flag = 0.0


func shutdown_sequence(delta, shutdown_duration):
	pass
