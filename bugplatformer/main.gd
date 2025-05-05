extends Node2D

var time = 0.0
var platforms = preload("res://polygon_1.tscn")

# Called when the node enters the scene tree for the first time.


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var x = 0
	var y = 0
	var amplitude = 18000
	var frequency =5
	var min_gap = 0
	var max_gap = 70
	var min_platform_width = 6
	var max_platform_width = 30
	var min_platform_height = 1
	var max_platform_height = 5
	var min_rotation = -10
	var max_rotation = 10
	for i in range(0, 1000):
		y = amplitude * sin(i / frequency) - 3000
		var platform_width = randi_range(min_platform_width, max_platform_width)
		var platform_height = randf_range(min_platform_height, max_platform_height)
		var platform_gap = randf_range(min_gap, max_gap)
		var ins = platforms.instantiate()
		ins.global_position = Vector2(x, y)
		ins.scale.x = platform_width
		ins.scale.y = platform_height	
		ins.rotation_degrees = randf_range(min_rotation, max_rotation)
		add_child(ins)
		x += platform_width + platform_gap
		if i % 50 == 0:
			amplitude += randf_range(-500, 500)
			frequency += randf_range(-0.1, 0.1)
			min_gap += randf_range(-10, 10)
			max_gap += randf_range(-10, 10)
			min_platform_width += randi_range(-1, 1)
			max_platform_width += randi_range(-1, 1)
			min_platform_height += randf_range(-0.1, 0.1)
			max_platform_height += randf_range(-0.1, 0.1)
			min_rotation += randf_range(-1, 1)
			max_rotation += randf_range(-1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta/50.0
	var _value = (sin(time - PI/2) + 1.0) /2.0 
	#$ParallaxBackground/ParallaxLayer/Sprite2D.modulate.a = value
	pass

