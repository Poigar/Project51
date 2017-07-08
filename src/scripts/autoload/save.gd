extends Node

var release = true;

const gamepath = "res://save.json"
const configpath = "res://settings.cfg"

var configFile = ConfigFile.new()

var settings = {
	"global": {
		"games": 0,
		"worldNames": ["","","","","",""]
	}
}

var currentGame = ""

func _ready():
	if release:
		gamepath = "user://save.json"
		configpath = "user://settings.cfg"
	
#	resetGame()
	
	var f = File.new()
	if f.file_exists(configpath):
		loadSettings()
	else:
		saveSettings()
		loadSettings()

func saveWorld(map,mapData):
	var worldToSave = {
		mapArray = map,
		width = mapData.width,
		height = mapData.height,
		customSeed = mapData.customSeed,
		islands = mapData.islands,
		name = mapData.name,
		path = ""
	}
	if release:
		worldToSave.path = "user://"+str(worldToSave.name)+".json"
	else:
		worldToSave.path = "res://"+str(worldToSave.name)+".json"
	
	var saveFile = File.new()
	saveFile.open(worldToSave.path, File.WRITE)
	saveFile.store_line(worldToSave.to_json())
	saveFile.close()
	
	settings.global.worldNames[settings.global.games]=worldToSave.name
	settings.global.games+=1
	saveSettings()

func deleteWorld(toDelete):
	
	var f = File.new()
	if release:
		if f.file_exists("user://"+str(toDelete)+".json"):
			var dir = Directory.new()
			dir.remove("user://"+str(toDelete)+".json")
			settings.global.games-=1
			for i in range(0,6):
				if settings.global.worldNames[i] == toDelete:
					settings.global.worldNames[i] = ""
					
			saveSettings()
	
	else:
		if f.file_exists("res://"+str(toDelete)+".json"):
			var dir = Directory.new()
			dir.remove("res://"+str(toDelete)+".json")
			settings.global.games-=1
			for i in range(0,6):
				if settings.global.worldNames[i] == toDelete:
					settings.global.worldNames[i] = ""
					
			saveSettings()
	
	
func loadWorld():
	pass

func saveGame():
	pass

func loadGame():
	pass
	
func resetGame():
	for _section in settings.keys():
		for _key in settings[_section]:
			configFile.set_value(_section,_key,settings[_section][_key])
	configFile.save(configpath)

func saveSettings():
	for _section in settings.keys():
		for _key in settings[_section]:
			configFile.set_value(_section,_key,settings[_section][_key])
	configFile.save(configpath)
func loadSettings():
	var error = configFile.load(configpath)
	if error != OK:
		print("ERROR" + str(error))
		return null
	for _section in settings.keys():
		for _key in settings[_section]:
			settings[_section][_key] = configFile.get_value(_section,_key,null)