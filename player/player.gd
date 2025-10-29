class_name Player extends CharacterBody2D

const SPEED = 100.0
const ROLL_SPEED = 120.0
# This is needed for the AnimationTree Expression (?)
var input_vector = Vector2.ZERO
var last_input_vector = Vector2.ZERO
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@onready var hitbox: Hitbox = $Hitbox

func _physics_process(delta: float) -> void:
	# StringName get_current_node() const
	#	Returns the currently playing animation state.
	var state = playback.get_current_node()
	match state:
		"MoveState":
			move_state(delta)
		"AttackState":
			attack_state(delta)
		"RollState":
			roll_state(delta)

func move_state(delta: float) -> void:
	# velocity = Vector2.ZERO
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Update only when moving
	if input_vector != Vector2.ZERO:
		hitbox.knockback_direction = input_vector.normalized()
		last_input_vector = input_vector
		var direction_vector := Vector2(input_vector.x, -input_vector.y)
		update_blend_positions(direction_vector)
	if Input.is_action_just_pressed("attack"):
		playback.travel("AttackState")
	if Input.is_action_just_pressed("roll"):
		playback.travel("RollState")
	# The velocity should not be set to a value multiplied by delta, because 
	# this happens internally in move_and_slide(). Otherwise, the simulation 
	# will run at an incorrect speed.
	velocity = input_vector * SPEED
	move_and_slide()

func attack_state(delta: float) -> void:
	pass

func roll_state(delta: float) -> void:
	velocity = last_input_vector.normalized() * ROLL_SPEED
	move_and_slide()
	
func update_blend_positions(direction_vector: Vector2) -> void:
	animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/AttackState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/RollState/blend_position", direction_vector)
