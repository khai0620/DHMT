extends CanvasLayer

func _on_start_game_button_pressed() -> void:
	# Đảm bảo GameManager đã được thêm vào Autoload trong Project Settings
	if has_node("/root/GameManager"): 
		GameManager.start_game()
		queue_free() # Xóa menu sau khi nhấn Start
	else:
		print("Lỗi: Không tìm thấy Autoload GameManager!")

func _on_exit_game_button_pressed() -> void:
	get_tree().quit() # Hoặc dùng GameManager.exit_game() nếu bạn đã viết hàm đó
