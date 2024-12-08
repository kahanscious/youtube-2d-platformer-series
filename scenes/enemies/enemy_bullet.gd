class_name EnemyBullet extends Bullet


func _ready() -> void:
	bullet_speed = 300.0


func _physics_process(_delta: float) -> void:
	var distance = abs(global_position.x - PlayerManager.player.global_position.x)
	if distance > 500:
		_destroy()
