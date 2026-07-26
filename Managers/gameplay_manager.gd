extends Node
class_name GameplayManager

@export_group("Refernces")
@export var level_root : Node3D
@export var enemy_scene : PackedScene
@export var enemy_spawn_pos : Node3D
@export var player_spawn_point : Node3D
@export var start_lever : StartLever
@export var player : PlayerBehavior
@export var collection_hole_move : Node
@export var countdown_timer_label : Label
@export var temp_gold_label : Label
@export var stored_gold_label : Label
@export var player_hp_label : Label

@export_group("Tracking")
enum GameState{Upgrading, Countdown, Overtime}
@export var current_state : GameState

@export var stored_gold : int = 0
@export var round_gold : int = 0

@export var overtimer_speedup_mod : float = 1
@export var round_countdown : float = 60
@export var _round_timer : float
@export var overtime : bool = false

var delayed_round_end_active : bool = false
var _delay_timer : float

@export_group("Coin Stuff")
@export var current_min_coin_value : int = 1
@export var current_max_coin_value : int = 3

@export_group("Spawn")
@export var enemy_spawn_cooldown : float = 20
var _spawn_timer : float = 0


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
			
			
			### ENEMY SPAWNING
			if _spawn_timer >= enemy_spawn_cooldown :
				SpawnEnemy()
				_spawn_timer = 0
			else :
				_spawn_timer += delta
			
			
			
		GameState.Overtime :
			collection_hole_move.follow_speed += (delta * overtimer_speedup_mod)
			
			_spawn_timer = 0
	
	if delayed_round_end_active :
		if _delay_timer > 0 :
			_delay_timer -= delta
		else :
			delayed_round_end_active = false
			_delay_timer = 0
			EndRound(false)


func StartRound() :
	SpawnEnemy()
	
	current_state = GameState.Countdown
	_round_timer = round_countdown
	collection_hole_move.SwitchToOrbit()
	
	# OpenGate()
	

func EndRound(player_survive : bool) :
	current_state = GameState.Upgrading
	collection_hole_move.SwitchToOrbit()
	
	
	
	if player_survive :
		StoreGold(round_gold)
	else :
		round_gold = 0
		_round_timer = 0
		var timer_string : String = String.num(_round_timer, 0)
		countdown_timer_label.text = timer_string
		ResetPlayerToPlayerSpawn()
	
	player.current_hp = player.max_hp
	UpdatePlayerHPLabel(player.current_hp, player.max_hp)
	
	# ShowShop()
	# DisablePlayerMovement()
	

func StartOvertime() :
	current_state = GameState.Overtime
	collection_hole_move.SwitchToFollow()
	
	
	var enemies : Array[Node] = get_tree().get_nodes_in_group("Enemy")
	for enemey in enemies :
		enemey.has_spawned_box = true
		enemey.Die()
	

func SpawnEnemy() :
	var new_enemy : Enemy = enemy_scene.instantiate()
	level_root.add_child(new_enemy)
	new_enemy.global_position = enemy_spawn_pos.global_position



func CollectTempGold(gold : int) :
	round_gold += gold
	temp_gold_label.text = str(round_gold)
	

func StoreGold(gold : int) :
	stored_gold += gold
	stored_gold_label.text = str(stored_gold)
	

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



func UpdatePlayerHPLabel(current_hp : float, max_hp : float) :
	var hp_string = String.num(current_hp, 0) + "/" + String.num(max_hp, 0)
	player_hp_label.text = hp_string





#
