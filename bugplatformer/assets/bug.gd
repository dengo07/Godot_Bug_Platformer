extends CharacterBody2D

var grav = 800
const  MAX_SPEED = 800
var vel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func camera_move(delta): 
	$Camera2D.global_position = lerp($Camera2D.global_position,global_position,2 * delta)
func fly(delta):
	if Input.is_action_pressed("jump"):
		velocity.y -=1000*delta
func snap():
	var floor_normal = Vector2.UP
	
	if is_on_floor():
		var collision = get_slide_collision(0)
		if collision != null:
			floor_normal = collision.get_normal()
			rotation = lerp(rotation,floor_normal.angle() +PI/2,0.5)
	elif is_on_ceiling() and Input.is_action_pressed("snap"):
		
		var collision = get_slide_collision(0)
		if collision != null:
			velocity.y =-1 
			floor_normal = collision.get_normal()
			rotation = lerp(rotation,floor_normal.angle() +PI/2,0.5)
	
	elif is_on_wall() and Input.is_action_pressed("snap"):
		var collision = get_slide_collision(0)
		if collision != null:
			
			floor_normal = collision.get_normal()
			rotation = floor_normal.angle() +PI/2
func x_movement(delta):
	if is_on_wall() and Input.is_action_pressed("snap"):
		if Input.is_action_pressed("up"):
			velocity.y = -10000*delta
			
		elif Input.is_action_pressed("down"):
			velocity.y = 10000*delta
	
	if(is_on_floor() !=true or !(is_on_ceiling() and  Input.is_action_pressed("snap"))):
		if Input.is_action_pressed("left"):
			velocity.x =clamp(velocity.x - 500 * delta, -MAX_SPEED, MAX_SPEED)
		
		elif Input.is_action_pressed("right"):
			velocity.x =clamp(velocity.x + 500 * delta, -MAX_SPEED, MAX_SPEED)

		else:
			velocity.x = lerp(velocity.x,0.0,0.01)
	if(is_on_floor() or (is_on_ceiling() and Input.is_action_pressed("snap"))):
		if Input.is_action_pressed("left"):
			velocity.x=-15000*delta
		
		elif Input.is_action_pressed("right"):
			velocity.x = 15000*delta
		else:
			velocity.x = lerp(velocity.x,0.0,0.6)
func gravity(delta):
	
	if is_on_floor() != true:
		velocity.y += grav*delta
func animation_handling():
	if(!(is_on_ceiling() and Input.is_action_pressed("snap"))):
		if Input.is_action_pressed("left"):
			$AnimatedSprite2D.flip_h = false
		
		elif Input.is_action_pressed("right"):
			$AnimatedSprite2D.flip_h = true
	elif(is_on_ceiling() and Input.is_action_pressed("snap")):
		if Input.is_action_pressed("left"):
			$AnimatedSprite2D.flip_h = true
		
		elif Input.is_action_pressed("right"):
			$AnimatedSprite2D.flip_h = false
			
		
			
	if(is_on_floor() !=true ):
		if !(is_on_ceiling() and Input.is_action_pressed("snap")):
			if velocity.x > 70:
				rotation_degrees= lerp(rotation_degrees,30.0,0.06)
			elif velocity.x < -70:
				rotation_degrees= lerp(rotation_degrees,-30.0,0.06)
		if is_on_ceiling():
			if Input.is_action_pressed("snap"):
				if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
					$AnimatedSprite2D.play("default")
				else:
					$AnimatedSprite2D.stop()
			
		if Input.is_action_pressed("jump"):
			if !(is_on_ceiling() and Input.is_action_pressed("snap")):
				if velocity.x > 70:
					rotation_degrees= lerp(rotation_degrees,30.0,0.06)
				elif velocity.x < -70:
					rotation_degrees= lerp(rotation_degrees,-30.0,0.06)
				else:
					rotation_degrees = lerp(rotation_degrees,0.0,0.06)
			
				$AnimatedSprite2D.play("flay")
			else:
				$AnimatedSprite2D.play("default")
		else:
			$AnimatedSprite2D.stop()
			#if velocity.x> 1000:
				#rotation_degrees +=10
			#elif velocity.x< -1000:
				#rotation_degrees -=10
			
	if is_on_floor():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			$AnimatedSprite2D.play("default")
		else:
			$AnimatedSprite2D.stop()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_move(delta)
	print(global_position.x)
	print(velocity.x)
	
func _physics_process(delta):
	vel = $vector/A.global_position-$vector/B.global_position
	fly(delta)
	x_movement(delta)
	gravity(delta)
	animation_handling()
	snap()
	move_and_slide()
	
	
	
