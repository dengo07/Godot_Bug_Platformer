extends CharacterBody2D

var grav = 800
const  MAX_SPEED = 800
var vel = Vector2.ZERO
var new_vel = Vector2.ZERO
var floor_normal = Vector2.ZERO
var isSnapped = false
var can_fly = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Control/staminabar.max_value = Global.max_stamina

func staminahandling(delta):
	
	$CanvasLayer/Control/staminabar.value = Global.stamina
	if $CanvasLayer/Control/staminabar.value <= 0:
		can_fly = false
	if isSnapped  == false and Input.is_action_pressed("jump"):
		Global.stamina -=10*delta
		

func camera_move(delta): 
	$Camera2D.global_position = lerp($Camera2D.global_position,global_position,2 * delta)
	if is_on_floor() and isSnapped == true:
		$Camera2D.offset.y = lerp($Camera2D.offset.y,-10.0,0.02)
	else:
		$Camera2D.offset.y = lerp($Camera2D.offset.y,-10.0,0.02)
		
	
func fly(delta):
	if can_fly == true:
		if Input.is_action_pressed("jump"):
			velocity.y -=1000*delta
	
			
			
		

func snap():
	var collision
	
	if ((is_on_floor()) or ((is_on_ceiling() or is_on_wall()) and Input.is_action_pressed("snap"))):
		collision = get_slide_collision(0)
		if collision != null or !Input.is_action_pressed("jump"):
			floor_normal = collision.get_normal() 
			rotation = floor_normal.angle() + PI/2.0
			isSnapped  = true
	if  collision == null:
		isSnapped  = false
		
	
		
func x_movement(delta):
	
		
	if(isSnapped  != true):
		if Input.is_action_pressed("left"):
			velocity.x =clamp(velocity.x - 500 * delta, -MAX_SPEED, MAX_SPEED)
		
		elif Input.is_action_pressed("right"):
			velocity.x =clamp(velocity.x + 500 * delta, -MAX_SPEED, MAX_SPEED)

		else:
			velocity.x = lerp(velocity.x,0.0,0.01)
	if(isSnapped  == true):
		velocity = -floor_normal.normalized()*200 +new_vel
		if is_on_ceiling():
			#if Input.is_action_pressed("jump"):
				#velocity  =floor_normal *10000 * delta+ new_vel
			if Input.is_action_pressed("left"):
				new_vel=+vel*600*delta
		
			elif Input.is_action_pressed("right"):
				new_vel= -vel*600*delta
			else: 
				new_vel.x = lerp(new_vel.x,0.0,0.8)
				new_vel.y = lerp(new_vel.y,0.0,0.8)
		
		elif is_on_wall():
			if Input.is_action_pressed("jump"):
				velocity  =floor_normal *10000 * delta  + new_vel
				
			if Input.is_action_pressed("left"):
				new_vel=vel*600*delta
			elif Input.is_action_pressed("right"):
				new_vel= -vel*600*delta
			else: 
				new_vel.x = lerp(new_vel.x,0.0,1.0)
				new_vel.y = lerp(new_vel.y,0.0,1.0)
		else:
			if Input.is_action_pressed("jump"):
				velocity  =floor_normal *10000 * delta + new_vel
			if Input.is_action_pressed("left"):
				new_vel=vel*600*delta
			
			elif Input.is_action_pressed("right"):
				new_vel= -vel*600*delta
			else:
				new_vel.x = lerp(new_vel.x,0.0,0.8)
				new_vel.y = lerp(new_vel.y,0.0,0.8)
	

func gravity(delta):
	
	if isSnapped  == false:
		velocity.y =clamp(velocity.y + grav * delta, -1000, +1000)
		
		
func animation_handling(delta):

	if(isSnapped ==true):
		if Input.is_action_pressed("left"):
			$AnimatedSprite2D.flip_h = false
		
		elif Input.is_action_pressed("right"):
			$AnimatedSprite2D.flip_h = true
	elif isSnapped  == false:
		if Input.is_action_pressed("left"):
			$AnimatedSprite2D.flip_h = false
		
		elif Input.is_action_pressed("right"):
			$AnimatedSprite2D.flip_h = true
	
	if isSnapped  == true:
		rotation_degrees= lerp(rotation_degrees,0.0,0.1 *delta)
		if Input.is_action_pressed("left") or  Input.is_action_pressed("right"):
			$AnimatedSprite2D.play("default")
		else:
			$AnimatedSprite2D.stop()
		
		
			
	elif isSnapped  == false:
		if velocity.x > 70:
			rotation_degrees= lerp(rotation_degrees,30.0,1.5 *delta)
		elif velocity.x < -70:
			rotation_degrees= lerp(rotation_degrees,-30.0,1.5 * delta)
		else:
			rotation_degrees= lerp(rotation_degrees,0.0,1.5 * delta)
			
			
		if Input.is_action_pressed("jump") and can_fly == true:
			$AnimatedSprite2D.play("flay")
	
		else:
			$AnimatedSprite2D.stop()
	
	elif Input.is_action_pressed("jump") and isSnapped  == true:
		$AnimatedSprite2D.stop()
		
	
func sound_manager():
	if(can_fly == true and Input.is_action_pressed("jump")):
		$AudioStreamPlayer2D.playing = true
	else:
		$AudioStreamPlayer2D.playing = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_move(delta)
	print(global_position.x)
	staminahandling(delta)
	print(is_on_wall())

func _physics_process(delta):
	vel = ($vector/B.global_position-$vector/A.global_position).normalized() *30
	
	fly(delta)
	x_movement(delta)
	gravity(delta)
	animation_handling(delta)
	move_and_slide()
	snap()
	
	
