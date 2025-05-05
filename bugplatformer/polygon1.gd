extends StaticBody2D

var num_vertices = 12
var min_radius = 100
var max_radius = 120

func _ready():
	
	generate_polygon()


func generate_polygon():

	var angle_increment = 2 * PI / num_vertices
	var center = Vector2(0, 0)
	var points = []
	for i in range(num_vertices):
		# Calculate a random radius for each vertex
		var radius = randf_range(min_radius, max_radius)
		# Add some randomness to the angle
		var angle = i * angle_increment + randf_range(-PI/16, PI/16)
		# Calculate the point based on the radius and angle
		var point = Vector2(radius * cos(angle), radius * sin(angle)) + center
		points.append(point)
	$Polygon2D.set_polygon(points)
	var polygon = $Polygon2D.get_polygon()
	
	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.set_polygon(polygon)
	add_child(collision_polygon)
