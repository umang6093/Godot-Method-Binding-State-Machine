class_name StateMachine
extends Node

@export var update: bool = true ## Wether or not to update the StateMachine

var state: int ## Integer to the state_id in the state_enum
var state_id: String ## String ID to the integer state in the state_enum
var state_enum: Dictionary ## Keys and Values for Integer and String based IDS

var input_ref: Callable ## Reduces Method lookup upon InputEvent
var update_ref: Callable ## Reduces Method lookup every frame
var fixed_update_ref: Callable ## Reduces Method lookup every physics frame


func _input(event: InputEvent):
	if update and input_ref.is_valid():
		input_ref.call(event)


func _physics_process(delta: float) -> void:
	if update and fixed_update_ref.is_valid():
		fixed_update_ref.call(delta)


func _process(delta: float) -> void:
	# Update Current State
	if update and update_ref.is_valid():
		update_ref.call(delta)


## Stores the enum for ID lookup
func set_state_enum(state_enum: Dictionary):
	self.state_enum = state_enum


## Sets the current state, calling proper Exit/Enter states
func set_state(new_state):
	if state_enum == null:
		return
	
	# Exit State
	_call_check("_" + state_id + "_exit")
	
	# Load new_state
	state = new_state
	state_id = state_enum.keys()[state].to_lower()
	_call_check("_" + state_id + "_enter")
	
	# Method Retrieving
	update_ref = Callable(self, "_" + state_id + "_update")
	fixed_update_ref = Callable(self, "_" + state_id + "_fixed_update")
	input_ref = Callable(self, "_" + state_id + "_input")


# Does null checking
func _call_check(method: String):
	# Null Check
	if not has_method(method) or state_id == null :
		return false
	call(method)
