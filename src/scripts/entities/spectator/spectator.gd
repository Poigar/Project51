extends Sprite

var camera

func _ready():
	camera = get_node("camera")
	set_process_input(true)
	set_process(true)


func _input(event):
	
	if Input.is_action_pressed("zoom_out"):
		var cur_zoom = camera.get_zoom()
		camera.set_zoom(Vector2(cur_zoom.x+0.1,cur_zoom.y+0.1))
	if Input.is_action_pressed("zoom_in"):
		var cur_zoom = camera.get_zoom()
		camera.set_zoom(Vector2(cur_zoom.x-0.1,cur_zoom.y-0.1))

func _process(delta):
	
	if Input.is_action_pressed("move_down"):
		var position = get_pos()
		set_pos(Vector2(position.x,position.y+(200*camera.get_zoom().x)*delta))
	if Input.is_action_pressed("move_up"):
		var position = get_pos()
		set_pos(Vector2(position.x,position.y-(200*camera.get_zoom().x)*delta))
	if Input.is_action_pressed("move_left"):
		var position = get_pos()
		set_pos(Vector2(position.x-(200*camera.get_zoom().x)*delta,position.y))
	if Input.is_action_pressed("move_right"):
		var position = get_pos()
		set_pos(Vector2(position.x+(200*camera.get_zoom().x)*delta,position.y))