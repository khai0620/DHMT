extends NodeState

@export var character: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D
@export var min_speed: float = 5.0
@export var max_speed: float = 10.0
var speed: float 

func _ready() -> void:
	# Chỉ kết nối tín hiệu đúng của Godot 4
	if !navigation_agent_2d.velocity_computed.is_connected(on_velocity_computed):
		navigation_agent_2d.velocity_computed.connect(on_velocity_computed)
	call_deferred("character_setup")

func character_setup() -> void:
	await get_tree().physics_frame
	set_movement_target()

func set_movement_target() -> void:
	var map = navigation_agent_2d.get_navigation_map()
	var target_position: Vector2 = NavigationServer2D.map_get_random_point(map, navigation_agent_2d.navigation_layers, false)
	navigation_agent_2d.target_position = target_position
	speed = randf_range(min_speed, max_speed)

func _on_physics_process(_delta : float) -> void:
	# Nếu đã đến đích, dừng lại và thoát hàm để tránh xoay tại chỗ
	if navigation_agent_2d.is_navigation_finished():
		character.velocity = Vector2.ZERO
		return

	var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var target_direction: Vector2 = character.global_position.direction_to(target_position)
	var velocity_to_set: Vector2 = target_direction * speed

	# Lật Sprite
	if target_direction.x != 0:
		animated_sprite_2d.flip_h = target_direction.x < 0

	# Kiểm tra Avoidance để dùng vận tốc đúng cách
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.velocity = velocity_to_set
	else:
		character.velocity = velocity_to_set
		character.move_and_slide()

# Chỉ dùng hàm này khi bật Avoidance
func on_velocity_computed(safe_velocity: Vector2) -> void:
	character.velocity = safe_velocity
	character.move_and_slide()

func _on_next_transitions() -> void:
	# Nếu đã đến đích thì mới cho phép chuyển sang Idle
	if navigation_agent_2d.is_navigation_finished():
		transition.emit("idle") # Đảm bảo tên "idle" khớp với Node Idle của bạn

func _on_enter() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.play("walk")
	set_movement_target()

func _on_exit() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.stop()
	character.velocity = Vector2.ZERO
