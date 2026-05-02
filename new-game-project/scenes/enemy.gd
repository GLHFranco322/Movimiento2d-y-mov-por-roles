extends CharacterBody2D

@onready var ray_der = $Node2D/RayCast2D
@onready var ray_izq = $Node2D/RayCast2D2

var speed_normal = 90
var speed_alerta = 200
var gravedad = 100

func _ready() -> void:
	velocity.x = speed_normal
	$AnimatedSprite2D.play("walk")

func _physics_process(delta: float) -> void:
	velocity.y += gravedad

	var speed_actual = speed_normal
	
	#si ve al jugador corre
	if ve_al_jugador():
		speed_actual = speed_alerta
	
	# cambia de direccion al chocas
	if is_on_wall():
		if !$AnimatedSprite2D.flip_h:
			velocity.x = speed_actual
		else:
			velocity.x = -speed_actual
	
	#asegura que se mueva todo el tiempo
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
		velocity.x = -speed_actual
		
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
		velocity.x = speed_actual
	
	move_and_slide()

#ve al jugador para ir a matarlo
func ve_al_jugador():
	if ray_der.is_colliding():
		var obj = ray_der.get_collider()
		if obj.is_in_group("player"):
			return true
	
	if ray_izq.is_colliding():
		var obj = ray_izq.get_collider()
		if obj.is_in_group("player"):
			return true
	
	return false
