extends Control

var settings = null
var release = false

func _ready():
	settings = get_node("/root/Data").settings
	if settings.global.games == 0:
		get_node("menu/load_world").set_disabled(true)
		release = get_node("/root/Data").release
	else:
		loadWorlds()


func _on_new_world_pressed():

	if get_node("newWorldPanel").is_visible():
		get_node("newWorldPanel").hide()
	else:
		get_node("newWorldPanel").show()
		get_node("loadWorldPanel").hide()


func _on_continue_pressed():
	
	var worldData = {
		"width":get_node("newWorldPanel/size").get_value(),
		"height":get_node("newWorldPanel/size").get_value(),
		"islands": get_node("newWorldPanel/islands").get_value(),
		"customSeed": get_node("newWorldPanel/seed").get_value(),
		"name": get_node("newWorldPanel/name").get_text()
	}
	
	if(worldData.name.length()>2 && settings.global.games <6):
		var generatedMap = get_node("generator").generateWorld(worldData.width,worldData.height,worldData.customSeed,worldData.islands,true,false,false,false)
		
		get_node("/root/Data").saveWorld(generatedMap,worldData)
		get_node("menu/load_world").set_disabled(false)
		get_node("newWorldPanel/errors").set_text("World created successfully!")
		for child in get_node("loadWorldPanel/worlds").get_children():
			get_node("loadWorldPanel/worlds").remove_child(child)
		loadWorlds()
	else:
		get_node("newWorldPanel/errors").set_text("Fill all fields")
		if settings.global.games==6:
			get_node("newWorldPanel/errors").set_text("Maximum amount of worlds reached!")


func loadWorlds():
	
	for i in range(0,6):
		var current = settings.global.worldNames[i]
		if current.length() > 1:
			get_node("loadWorldPanel/name").set_text(str(current))
			var obj = load("res://scenes/ui/world_name.tscn").instance()
			obj.set_text(str(current))
			get_node("loadWorldPanel/worlds").add_child(obj)

func _on_load_world_pressed():
	var toLoad = get_node("loadWorldPanel/name").get_text()
	for i in range(0,6):
		var current = settings.global.worldNames[i]
		if current == toLoad:
			get_node("/root/Data").currentGame = toLoad
			get_tree().change_scene("res://scenes/world/world_scene.tscn")

func _on_delete_world_pressed():
	var toDelete = get_node("loadWorldPanel/name").get_text()
	get_node("/root/Data").deleteWorld(toDelete)
	
	for child in get_node("loadWorldPanel/worlds").get_children():
		get_node("loadWorldPanel/worlds").remove_child(child)
	
	loadWorlds()


func _on_load_pressed():
	if get_node("loadWorldPanel").is_visible():
		get_node("loadWorldPanel").hide()
	else:
		get_node("newWorldPanel").hide()
		get_node("loadWorldPanel").show()
