extends Node3D
class_name StartLever

var gameplay_manager: GameplayManager

@export var anim_player : AnimationPlayer
@export var gate_anim : AnimationPlayer
var flipped : bool = false

var on_cooldown : bool = false
@export var flip_cooldown : float = 2
var _flip_timer : float = 0


func _ready() -> void:
	gameplay_manager = get_tree().get_first_node_in_group("GameplayManager")

func _process(delta: float) -> void:
	if on_cooldown :
		_flip_timer += delta
		if _flip_timer >= flip_cooldown :
			on_cooldown = false
			_flip_timer = 0

func FlipLever() :
	if not on_cooldown :
		on_cooldown = true
		var temp : bool = flipped
		flipped = gameplay_manager.FlipLeverEvent()
		
		if temp != flipped :
			if temp :
				anim_player.play("on_to_off")
				gate_anim.play("open_to_close")
			else :
				anim_player.play("off_to_on")
				gate_anim.play("close_to_open")

func ForceResetLever() :
	anim_player.play("on_to_off")
	gate_anim.play("open_to_close")
	flipped = false
	
