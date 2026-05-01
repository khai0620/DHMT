extends NodeState

@export var character: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D

@export var min_speed: float = 5.0
@export var max_speed: float = 10.0

# Layer của gà
@export var chicken_collision_mask: int = 2

# Khoảng cách nhìn phía trước
@export var detect_distance: float = 20.0

# Thời gian đứng chờ
@export var wait_time: float = 1.0

var speed: float
var waiting: bool = false
var wait_timer: float = 0.0


func _ready() -> void:

	# Bật avoidance
	navigation_agent_2d.avoidance_enabled = true

	# Kết nối signal avoidance
	if !navigation_agent_2d.velocity_computed.is_connected(on_velocity_computed):
		navigation_agent_2d.velocity_computed.connect(on_velocity_computed)

	call_deferred("character_setup")


func character_setup() -> void:
	await get_tree().physics_frame
	set_movement_target()


func set_movement_target() -> void:

	var map = navigation_agent_2d.get_navigation_map()

	var target_position: Vector2 = NavigationServer2D.map_get_random_point(
		map,
		navigation_agent_2d.navigation_layers,
		false
	)

	navigation_agent_2d.target_position = target_position

	speed = randf_range(min_speed, max_speed)


func _on_physics_process(delta: float) -> void:

	# Đang đứng chờ
	if waiting:

		wait_timer -= delta

		character.velocity = Vector2.ZERO
		navigation_agent_2d.velocity = Vector2.ZERO

		character.move_and_slide()

		if wait_timer <= 0:

			waiting = false

			if animated_sprite_2d:
				animated_sprite_2d.play("walk")

		return

	# Tới đích
	if navigation_agent_2d.is_navigation_finished():

		character.velocity = Vector2.ZERO
		character.move_and_slide()

		return

	# Nếu có gà phía trước thì dừng lại
	if chicken_in_front():

		waiting = true
		wait_timer = wait_time

		character.velocity = Vector2.ZERO
		navigation_agent_2d.velocity = Vector2.ZERO

		character.move_and_slide()

		if animated_sprite_2d:
			animated_sprite_2d.play("idle")

		return

	# Lấy điểm tiếp theo trên path
	var next_position: Vector2 = navigation_agent_2d.get_next_path_position()

	var direction: Vector2 = character.global_position.direction_to(next_position)

	# Flip sprite
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0

	# Animation
	if animated_sprite_2d.animation != "walk":
		animated_sprite_2d.play("walk")

	# Dùng avoidance
	navigation_agent_2d.velocity = direction * speed


func on_velocity_computed(safe_velocity: Vector2) -> void:

	# Nếu đang chờ thì không cho di chuyển
	if waiting:
		character.velocity = Vector2.ZERO
	else:
		character.velocity = safe_velocity

	character.move_and_slide()


func chicken_in_front() -> bool:

	var space_state = character.get_world_2d().direct_space_state

	var next_position: Vector2 = navigation_agent_2d.get_next_path_position()

	var direction: Vector2 = character.global_position.direction_to(next_position)

	var query := PhysicsRayQueryParameters2D.create(
		character.global_position,
		character.global_position + direction * detect_distance
	)

	# Chỉ check layer gà
	query.collision_mask = 1 << (chicken_collision_mask - 1)

	# Bỏ qua chính mình
	query.exclude = [character]

	var result = space_state.intersect_ray(query)

	if result:
		return true

	return false


func _on_next_transitions() -> void:

	if navigation_agent_2d.is_navigation_finished() and !waiting:
		transition.emit("idle")


func _on_enter() -> void:

	waiting = false

	if animated_sprite_2d:
		animated_sprite_2d.play("walk")

	set_movement_target()


func _on_exit() -> void:

	if animated_sprite_2d:
		animated_sprite_2d.stop()

	character.velocity = Vector2.ZERO