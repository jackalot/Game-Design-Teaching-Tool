extends CharacterBody2D

#Toggles different features
@export var JumpToHold = true
@export var CoyoteTimeEnabled = true
const SPEED = 300.0
const JUMP_VELOCITY = -200.0
#Child Nodes
var _coyote_timer
var _animated_sprite
# Jump booleans
var jump_hold = false
var can_jump = true
func _onready():
	_coyote_timer = $"Coyote Timer"
	_animated_sprite = $AnimatedSprite2D
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("Jump"):
		jump_hold = false
func _physics_process(delta: float) -> void:
	#============================================
	# JUMP MECHANICS AND COYOTE TIME
	#===========================================
	if not is_on_floor():
		#start the timer, give an opportunity to jump
		if CoyoteTimeEnabled:
			_coyote_timer.start()
		if JumpToHold == true:
			var holding: bool = Input.is_action_pressed("Jump") and jump_hold
			var jump_modifier: float = 0.5 if holding else 1.0
			velocity.y += get_gravity().y * delta * jump_modifier
		else:
			var jump_modifier = 0.5
			velocity.y += get_gravity().y * delta * jump_modifier
	else:
		can_jump = true
	if Input.is_action_just_pressed("Jump"):
		if(can_jump == true):
			velocity.y = JUMP_VELOCITY
			jump_hold = true
			can_jump = false
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

# Handles the Animaitons for movement
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


func _on_coyote_timer_timeout() -> void:
	can_jump = false
	print("Coyote Time is done")
