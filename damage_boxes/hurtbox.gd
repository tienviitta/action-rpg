class_name Hurtbox extends Area2D

signal hurt(hitbox: Hitbox)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area_2d: Hitbox) -> void:
	if area_2d is not Hitbox:
		return
	hurt.emit(area_2d)
