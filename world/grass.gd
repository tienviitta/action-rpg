extends Node2D

@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.area_entered.connect(_on_area_2d_area_entered)

func _on_area_2d_area_entered(other_area_2d: Area2D) -> void:
	queue_free()
	print("Grass area entered!")
