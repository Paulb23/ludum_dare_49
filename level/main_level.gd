extends Node3D

func _on_Area3D_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$player.respawn()
		if $player.keys_collected == 0:
			get_tree().call_group("level_1", "reset_puzzle")

func _on_player_key_collected() -> void:
	print("level 2!")
