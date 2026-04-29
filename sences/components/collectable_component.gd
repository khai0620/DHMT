class_name CollectableComponent
extends Area2D

@export var collectable_name: String

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
<<<<<<< HEAD
		print('Collected:', collectable_name)
=======
		print('Collected')
>>>>>>> 4af9f8d (Đàn gà)
		get_parent().queue_free()
