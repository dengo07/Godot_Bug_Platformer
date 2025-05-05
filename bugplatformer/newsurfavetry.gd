extends StaticBody2D

 # Add your generated control points here
var points = []
var pointcount = 40
var startendpoint:Vector2

func _ready():
	var collision = CollisionPolygon2D.new()
	var curve = $Path2D.curve
	var start_x = global_position.x
	var start_y = global_position.y +1000
	var randomy = global_position.y
	startendpoint = Vector2(start_x,start_y)
	var x  = start_x
	var y = randomy
	points.append(startendpoint)
	for i in range(pointcount): 
		
		points.append(Vector2(x, y))
		y=10
		x+=randf_range(150,1000)
	
		if y>=0:
			while(y>0):
				y = randf_range(randomy-300,randomy-100)

	points.append(Vector2(x,startendpoint.y))
	
	

	
	var i=0
	for point in points:
		curve.add_point(point)
		
	while i< pointcount:
		var x1 =randi_range(0,100)
		var y1 = x1
		curve.set_point_out(i,Vector2(x1,-y1))
		curve.set_point_in(i,Vector2(-x1,y1))
		i+=1
	add_child(collision)
	var polygon = curve.get_baked_points()
	$Polygon2D.polygon = polygon
	$Line2D.points = polygon
	collision.polygon = polygon
	$LightOccluder2D.occluder.polygon = polygon
