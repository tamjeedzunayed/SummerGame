extends CharacterBody2D

@onready var navigation_agent_2d = $NavigationAgent2D

const SPEED = 130.0

func _physics_process(delta):
	var dir : Vector2 = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	
	if !navigation_agent_2d.is_navigation_finished():
		velocity = lerp(velocity, dir * SPEED, 0.1);
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.1)
	
	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("LMB"):
		navigation_agent_2d.target_position = get_global_mouse_position()
