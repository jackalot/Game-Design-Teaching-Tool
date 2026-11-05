extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var _animated_sprite = $AnimatedSprite2D
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		MoveHorizontally(velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		MoveHorizontally(velocity)
	move_and_slide()

func MoveHorizontally(velocity):
	#Move Right
	if (velocity.x > 0):
		_animated_sprite.flip_h = false
		_animated_sprite.play("Run")
	else:
		#Move Left 
		if (velocity.x < 0):
			_animated_sprite.flip_h = true
			_animated_sprite.play("Run")
		else:
			#Idle
			if (velocity.x == 0):
				_animated_sprite.play("Idle")
	pass
