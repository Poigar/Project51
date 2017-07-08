extends Control

var tileKeys = {
	"sand": 0,
	"grass": 1,
	"water_s": 2,
	"water_d": 3,
}

var map = []

var mapWidth=0
var mapHeight=0

func _ready():
	pass


func generateWorld(width,height,cseed,islands,sand,ponds,lakes,rivers):
	
	_newResponse("Starting generation...")
	mapWidth=width
	mapHeight=height
	
	for i in range(0,mapHeight):
		map.append([])
		for j in range(0,mapWidth):
			map[i].append(0)
	
	seed(cseed) # Sets seed
	
	# Generates the water square
	_addWater(width,height)
	
	# Add n islands
	for i in range(0,islands):
		_newResponse("Adding island("+str(i+1)+")")
		_addIsland()
	
	if ponds == false:
		_removePonds(width,height)
	
	_addSand()
	
	_addShallowWater(width,height)
	
	_newResponse("New world created successfully!")
	return map

func _addWater(width,height):
	_newResponse("Adding water...")
	
	for h in range(0,height):
		for w in range(0,width):
			map[h][w] = tileKeys.water_d

func _removePonds(width,height):
	for h in range(0,height):
		for w in range(0,width):
			if map[h][w]==tileKeys.water_d or map[h][w]==tileKeys.water_s:
				if isKey(w,h-1,tileKeys.grass) && isKey(w,h+1,tileKeys.grass) && isKey(w-1,h,tileKeys.grass) && isKey(w+1,h,tileKeys.grass):
					map[h][w]=tileKeys.grass
				
func _addShallowWater(width,height):
	for h in range(0,height):
		for w in range(0,width):
			if map[h][w]==tileKeys.water_d or map[h][w]==tileKeys.water_s:
				if isKey(w,h-1,tileKeys.sand):
					map[h][w]=tileKeys.water_s
				if isKey(w,h+1,tileKeys.sand):
					map[h][w]=tileKeys.water_s
				if isKey(w+1,h,tileKeys.sand):
					map[h][w]=tileKeys.water_s
				if isKey(w-1,h,tileKeys.sand):
					map[h][w]=tileKeys.water_s
				
				if isKey(w,h-2,tileKeys.sand):
					map[h][w]=tileKeys.water_s
				if isKey(w,h+2,tileKeys.sand):
					map[h][w]=tileKeys.water_s
				if isKey(w+2,h,tileKeys.sand):
					map[h][w]=tileKeys.water_s
				if isKey(w-2,h,tileKeys.sand):
					map[h][w]=tileKeys.water_s

func _addIsland():
	#Get random starting position and size
	var start = Vector2(r(10,mapWidth-10),r(10,mapHeight-10))
	var size = r(100,500)
	
	#Array used by floodfill
	var nodes = Array()
	nodes.append(start)
	map[start.y][start.x]=tileKeys.grass
	
	while(size>0 && nodes.empty()==false ):
		var tmp = nodes.front() #Current tile cell
		var up = rb(1,100)
		var down = rb(1,100)
		var left = rb(1,100)
		var right = rb(1,100)
		
		if up && tmp.y>0 && isKey(tmp.x,tmp.y-1,tileKeys.water_d):
			size-=1
			map[tmp.y-1][tmp.x]=tileKeys.grass
			nodes.append(Vector2(tmp.x,tmp.y-1))
		
		if down && tmp.y<mapHeight-1 && isKey(tmp.x,tmp.y+1,tileKeys.water_d):
			size-=1
			map[tmp.y+1][tmp.x]=tileKeys.grass
			nodes.append(Vector2(tmp.x,tmp.y+1))
		if left && tmp.x>0 && isKey(tmp.x-1,tmp.y,tileKeys.water_d):
			size-=1
			map[tmp.y][tmp.x-1]=tileKeys.grass
			nodes.append(Vector2(tmp.x-1,tmp.y))
		if right && tmp.x<mapWidth-1 && isKey(tmp.x+1,tmp.y,tileKeys.water_d):
			size-=1
			map[tmp.y][tmp.x+1]=tileKeys.grass
			nodes.push_back(Vector2(tmp.x+1,tmp.y))
			
		nodes.pop_front()

func _addSand():
	_newResponse("Adding sand...")
	
	for h in range(0,mapHeight):
		for w in range(0,mapWidth):
			if map[h][w] == tileKeys.water_d:
				if isKey(w,h-1,tileKeys.grass): # UP
					map[h-1][w] = tileKeys.sand
				if isKey(w,h+1,tileKeys.grass): # DOWN
					map[h+1][w] = tileKeys.sand
				if isKey(w+1,h,tileKeys.grass): # RIGHT
					map[h][w+1] = tileKeys.sand
				if isKey(w-1,h,tileKeys.grass): # LEFT
					map[h][w-1] = tileKeys.sand
					
				if isKey(w-1,h-1,tileKeys.grass): # UP LEFT
					map[h-1][w-1] = tileKeys.sand
				if isKey(w+1,h-1,tileKeys.grass): # UP RIGHT
					map[h-1][w+1] = tileKeys.sand
				if isKey(w-1,h+1,tileKeys.grass): # DOWN LEFT
					map[h+1][w-1] = tileKeys.sand
				if isKey(w+1,h+1,tileKeys.grass): # DOWN RIGHT
					map[h+1][w+1] = tileKeys.sand

# Short random int selection
func r(from, to):
	return range(from,to)[randi()%range(from,to).size()]

# Returns true or false - like a random choice between two things
func rb(from, to):
	var chance = range(from,to)[randi()%range(from,to).size()]
	
	if chance > to/3:
		return true
	else:
		return false

# Is this cell frer
func isKey(x,y,n):
	if (x >= 0 && x<mapWidth) && (y>=0 && y<mapHeight):
		if map[y][x] == n:
			return true
		else:
			return false
	else:
		return false

func _newResponse(response):
	get_node("panel/Label").set_text(response)