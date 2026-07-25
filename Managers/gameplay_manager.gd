extends Node
class_name GameplayManager

@export_group("Refernces")
@export var player_spawn_point : Node3D
@export var player : PlayerBehavior
@export var collection_hole_move : Node
@export var countdown_timer_label : Label
@export var round_gold_label : Label
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


func _ready() -> void :
	_round_timer = round_countdown

func _process(delta: float) -> void :
	if Input.is_action_just_pressed("temp_restart") :
		current_state = GameState.Upgrading
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

func EndRound(player_survive : bool) :
	current_state = GameState.Upgrading
	
	if player_survive :
		StoreGold(round_gold)
	else :
		round_gold = 0
		ResetPlayerToPlayerSpawn()

func StartOvertime() :
	current_state = GameState.Overtime
	collection_hole_move.move_mode = collection_hole_move.MoveMode.Follow
	
	


func CollectGold(gold : int) :
	round_gold += gold
	

func StoreGold(gold : int) :
	stored_gold += gold
	


func DelayedEndRound(delay : float) :
	delayed_round_end_active = true
	_delay_timer = delay
	

func ResetPlayerToPlayerSpawn() :
	print("Wha")
	player.ResetToPlayerSpawn()







#
