class_name GrowthCycleComponent
extends Node

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var days_until_harvest: int = 7

signal crop_maturity
signal crop_harvesting

var is_watered: bool = false
var starting_day: int = -1 # Khởi tạo là -1 để tránh trùng với ngày 0
var current_day: int

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	if is_watered:
		if starting_day == -1:
			starting_day = day
		
		# Luôn cập nhật ngày hiện tại
		current_day = day
		
		# Gọi logic phát triển
		growth_states(starting_day, current_day)
		harvest_state(starting_day, current_day)
		
		# Sau khi lớn thêm 1 nấc, reset trạng thái tưới nước 
		# (Tùy thuộc vào game của bạn có bắt tưới mỗi ngày không)
		# is_watered = false 

func growth_states(p_starting_day: int, p_current_day: int):
	if current_growth_state >= DataTypes.GrowthStates.Maturity:
		return
	
	# Tính toán số ngày đã trôi qua kể từ khi bắt đầu trồng
	var total_days_passed = p_current_day - p_starting_day
	
	# Tính toán state dựa trên tổng thời gian (ví dụ có 5 states)
	var num_states = 5
	# Mỗi state sẽ chiếm khoảng bao nhiêu ngày:
	var days_per_state = float(days_until_harvest) / num_states
	
	var state_index = int(total_days_passed / days_per_state)
	
	# Đảm bảo state_index không vượt quá Maturity
	if state_index > DataTypes.GrowthStates.Maturity:
		state_index = DataTypes.GrowthStates.Maturity
		
	if current_growth_state != state_index:
		current_growth_state = state_index as DataTypes.GrowthStates
		print("Trạng thái mới: ", DataTypes.GrowthStates.keys()[current_growth_state])
		
		if current_growth_state == DataTypes.GrowthStates.Maturity:
			crop_maturity.emit()

func harvest_state(p_starting_day: int, p_current_day: int) -> void:
	# Cây chỉ có thể thu hoạch khi đã đủ số ngày
	if p_current_day - p_starting_day >= days_until_harvest:
		if current_growth_state != DataTypes.GrowthStates.Harvesting:
			current_growth_state = DataTypes.GrowthStates.Harvesting
			crop_harvesting.emit()
			print("Cây đã có thể thu hoạch!")

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state
