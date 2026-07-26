extends Node
class_name GameplayManager

@export_group("Refernces")
@export var player_spawn_point : Node3D
@export var gate : Node3D #######
@export var start_lever : StartLever
@export var player : PlayerBehavior
@export var collection_hole_move : Node
@export var countdown_timer_label : Label
@export var temp_gold_label : Label
@export var stored_gold_label : Label

@export_group("Tracking")
enum GameState{Upgrading, Countdown, Overtime}
@export var current_state : GameState

@export var stored_gold : int = 0
@export var round_gold : int = 0

@export var round_countdown : float = 45
@export var _round_timer : float
@export var overtime : bool = false

var delayed_round_end_active : bool = false
var _delay_timer : float

@export_group("Coin Stuff")
@export var current_min_coin_value : int = 1
@export var current_max_coin_value : int = 3

func _ready() -> void :
	_round_timer = round_countdown
	current_state = GameState.Upgrading


func _process(delta: float) -> void :
	if Input.is_action_just_pressed("temp_restart") :
		current_state = GameState.Upgrading
		countdown_timer_label.text = str(0)
		ResetPlayerToPlayerSpawn()
	
	
	match current_state :
		GameState.Upgrading :
			pass
			
		GameState.Countdown :
			if _round_timer <= 0 :
				_round_timer = 0
				StartOvertime()
				overtime = true
			else :
				_round_timer -= delta
			
			var timer_string : String = String.num(_round_timer, 0)
			countdown_timer_label.text = timer_string
			
		GameState.Overtime :
			# Hole gets larger and faster
			pass
	
	if delayed_round_end_active :
		if _delay_timer > 0 :
			_delay_timer -= delta
		else :
			delayed_round_end_active = false
			_delay_timer = 0
			EndRound(false)


func StartRound() :
	current_state = GameState.Countdown
	_round_timer = round_countdown
	collection_hole_move.move_mode = collection_hole_move.MoveMode.Orbit
	
	# OpenGate()
	

func EndRound(player_survive : bool) :
	current_state = GameState.Upgrading
	collection_hole_move.move_mode = collection_hole_move.MoveMode.Orbit
	if player_survive :
		StoreGold(round_gold)
	else :
		round_gold = 0
		_round_timer = 0
		var timer_string : String = String.num(_round_timer, 0)
		countdown_timer_label.text = timer_string
		ResetPlayerToPlayerSpawn()
	
	# CloseGate()
	# ShowShop()
	# DisablePlayerMovement()
	

func StartOvertime() :
	current_state = GameState.Overtime
	collection_hole_move.move_mode = collection_hole_move.MoveMode.Follow
	

func CollectTempGold(gold : int) :
	round_gold += gold
	temp_gold_label.text = str(round_gold)
	

func StoreGold(gold : int) :
	stored_gold += gold
	

func TrySpendGold(gold_spend : int) -> bool :
	if gold_spend <= stored_gold :
		return true
	else :
		return false
	

func DelayedEndRound(delay : float) :
	delayed_round_end_active = true
	_delay_timer = delay
	

func ResetPlayerToPlayerSpawn() :
	player.ResetToPlayerSpawn()
	start_lever.ForceResetLever()

func FlipLeverEvent() -> bool :
	if current_state == GameState.Upgrading :
		StartRound()
		return true
	elif current_state == GameState.Overtime :
		EndRound(true)
		return false
	else :
		return true


func UpdateMinCoinValue(new_value : int) :
	current_min_coin_value = new_value

func UpdateMaxCoinValue(new_value : int) :
	current_max_coin_value = new_value



#
