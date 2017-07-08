extends KinematicBody2D

# How fast he moves
const speed = 100
var camera = null

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
	camera = get_node("player_camera")

func _input(event):
	if Input.is_action_pressed("zoom_out"):
		var cur_zoom = camera.get_zoom()
		camera.set_zoom(Vector2(cur_zoom.x+0.1,cur_zoom.y+0.1))
	if Input.is_action_pressed("zoom_in"):
		var cur_zoom = camera.get_zoom()
		camera.set_zoom(Vector2(cur_zoom.x-0.1,cur_zoom.y-0.1))

func _fixed_process(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("move_down"):
		velocity.y=speed*delta
		get_node("player_sprite").set_animation("idle_front")
	if Input.is_action_pressed("move_up"):
		velocity.y=-speed*delta
		get_node("player_sprite").set_animation("idle_back")
	if Input.is_action_pressed("move_left"):
		velocity.x=-speed*delta
		get_node("player_sprite").set_animation("idle_left")
	if Input.is_action_pressed("move_right"):
		velocity.x=speed*delta
		get_node("player_sprite").set_animation("idle_right")
	
	var motion = move(velocity)
	
	if (is_colliding()):
        var n = get_collision_normal()
        motion = n.slide(motion)
        velocity = n.slide(velocity)
        move(motion)
	
