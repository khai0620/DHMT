class_name GrowthCycleComponent
extends Node

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var days_until_harvest: int = 7

signal crop_maturity
signal crop_harvesting

var is_watered: bool = false
var starting_day: int = -1 
var current_day: int

func _ready() -> void:
	# Kết nối với hệ thống thời gian
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	if is_watered:
		# Thiết lập ngày bắt đầu nếu đây là lần đầu tiên được tưới
		if starting_day == -1:
			starting_day = day
		
		current_day = day
		
		# Chạy logic tăng trưởng
		growth_states(starting_day, current_day)
		harvest_state(starting_day, current_day)
		
		# Lưu ý: Nếu game yêu cầu mỗi ngày phải tưới 1 lần, hãy bỏ comment dòng dưới:
		# is_watered = false 

func growth_states(p_starting_day: int, p_current_day: int):
	# Nếu cây đã trưởng thành hoặc đang thu hoạch thì không tính nữa
	if current_growth_state >= DataTypes.GrowthStates.Maturity:
		return
	
	var total_days_passed = p_current_day - p_starting_day
	
	# Nếu là ngày đầu tiên tưới (ngày 0), giữ nguyên trạng thái hạt giống ban đầu
	if total_days_passed <= 0:
		return

	# Tính toán số giai đoạn (ví dụ: 5 giai đoạn từ Sprout đến Maturity)
	var num_states = 5
	var days_per_state = float(days_until_harvest) / num_states
	
	# Sử dụng ceil để đảm bảo ngay khi qua ngày mới, cây sẽ tiến tới stage tiếp theo
	# thay vì chia ra 0 rồi quay lại hình hạt giống
	var state_index = ceil(total_days_passed / days_per_state)
	
	# Ép kiểu và giới hạn index trong phạm vi của Enum
	var target_state = clampi(int(state_index), 0, DataTypes.GrowthStates.Maturity)
	
	# Chỉ cập nhật và emit signal nếu trạng thái thực sự thay đổi
	if current_growth_state != target_state:
		current_growth_state = target_state as DataTypes.GrowthStates
		var state_name = DataTypes.GrowthStates.keys()[current_growth_state]
		print("Cây lớn lên! Giai đoạn: ", state_name)
		
		if current_growth_state == DataTypes.GrowthStates.Maturity:
			crop_maturity.emit()

func harvest_state(p_starting_day: int, p_current_day: int) -> void:
	# Cây có thể thu hoạch khi số ngày trôi qua lớn hơn hoặc bằng thời gian quy định
	if p_current_day - p_starting_day >= days_until_harvest:
		if current_growth_state != DataTypes.GrowthStates.Harvesting:
			current_growth_state = DataTypes.GrowthStates.Harvesting
			crop_harvesting.emit()
			print("--- Cây đã sẵn sàng thu hoạch! ---")

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state
