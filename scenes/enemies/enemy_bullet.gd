class_name EnemyBullet extends Bullet


func _physics_process(delta: float) -> void:
	var distance = abs(global_position.x - PlayerManager.player.global_position.x)
	if distance > 500:
		_destroy()
