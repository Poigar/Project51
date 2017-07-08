extends Node2D

var settings = null
var data = null

var map = null
var tilemap = null

var tileKeys = {
	"sand": 0,
	"grass": 1,
	"water_s": 2,
	"water_d": 3,
}

func _ready():
	data = get_node("/root/Data")
	settings = data.settings
	tilemap = get_node("map")
	
	_loadMap()
	

func _loadMap():
	var worldFile = File.new();
	
	if get_node("/root/Data").release:
		worldFile.open("user://"+str(data.currentGame)+".json", File.READ)
		var data = {}
		data.parse_json(worldFile.get_as_text())
		map = data
	
	else:
		worldFile.open("res://"+str(data.currentGame)+".json", File.READ)
		var data = {}
		data.parse_json(worldFile.get_as_text())
		map = data
	
#	print(map)
	_renderMap()

func _renderMap():
	for y in range(0,map.width):
		for x in range(0,map.height):
			tilemap.set_cell(x,y,map.mapArray[y][x])
	
	spawnPlayer()

func spawnPlayer():
	var spx = r(10,map.width-10)
	var spy = r(10,map.height-10)
	
	while(map.mapArray[spy][spx]==tileKeys.water_d || map.mapArray[spy][spx]==tileKeys.water_s):
		spx = r(10,map.width-10)
		spy = r(10,map.height-10)
	
	get_node("player_root/player_body").set_pos(Vector2(spx*32,spy*32))
func r(from, to):
	return range(from,to)[randi()%range(from,to).size()]