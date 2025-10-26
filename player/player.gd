extends CharacterBody2D
const SPEED = 100.0
# This is needed for the AnimationTree Expression (?)
var input_vector = Vector2.ZERO
@onready var animation_tree: AnimationTree = $AnimationTree
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	input_vector = Input.get_vector("ui_left", "ui_right", "ui_up","ui_down")
	# Update only when moving
	if input_vector != Vector2.ZERO:
		var direction_vector := Vector2(input_vector.x, -input_vector.y)
		# animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", direction_vector)
		# animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position", direction_vector)
		update_blend_positions(direction_vector)
	# The velocity should not be set to a value multiplied by delta, because 
	# this happens internally in move_and_slide(). Otherwise, the simulation 
	# will run at an incorrect speed.
	velocity = input_vector * SPEED
	move_and_slide()

func update_blend_positions(direction_vector: Vector2) -> void:
	animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position", direction_vector)
