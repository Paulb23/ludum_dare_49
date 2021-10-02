extends Node3D

func _on_Area3D_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$player.respawn()
		if $player.keys_collected == 0:
			get_tree().call_group("level_1", "reset_puzzle")
		if $player.keys_collected == 2:
			get_tree().call_group("level_2", "reset_puzzle")

func _on_player_key_collected() -> void:
	if $player.keys_collected == 1:
		$level_2_gate.open()
	if $player.keys_collected == 2:
		$level_3_gate.open()
	if $player.keys_collected == 3:
		$level_4_gate.open()
	if $player.keys_collected == 4:
		# start final
		pass

func _on_player_beakers_passed() -> void:
	$"level_4/beakers/beaker3".visible = false
	$"red_key_box".visible = true
	$"red_key".visible = true


func _on_player_locks_open() -> void:
		$level_5_gate.open()
		$level_5_gate2.open()


func _on_Area3D_final_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$player.respawn()
