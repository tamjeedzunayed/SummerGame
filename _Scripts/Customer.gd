extends CharacterBody2D

@onready var navigation_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

const SPEED : float = 130.0

func _physics_process(_delta):
	var dir : Vector2
	if !navigation_agent.is_navigation_finished():
		dir = to_local(navigation_agent.get_next_path_position()).normalized()
	else:
		dir = Vector2.ZERO
	
	
	if (dir.dot(Vector2.UP) > 0.7):
		animated_sprite.play("up")
	elif (dir.dot(Vector2.RIGHT) > 0.5):
		animated_sprite.play("left")
		animated_sprite.flip_h = true
	elif (dir.dot(Vector2.LEFT) > 0.5):
		animated_sprite.play("left")
		animated_sprite.flip_h = false
	else:
		animated_sprite.play("down")
		
	velocity = lerp(velocity, dir * SPEED, 0.1);
	
	move_and_slide()

func _input(_event):
	if Input.is_action_just_pressed("LMB"):
		navigation_agent.target_position = get_global_mouse_position()
