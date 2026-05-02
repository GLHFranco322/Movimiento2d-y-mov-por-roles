extends CharacterBody2D

#variables
var speed = 15000
var charge = 0
@onready var anim = $AnimatedSprite2D
var gravedad = 0
var can_jump = true
var timerOn = false
@export var salud = 1
var muerto = false


func _physics_process(delta: float) -> void:
	#declaramos botones para movernos en 2 direcciones
	var direction = Input.get_axis('left', 'right')
	
	#suma la variable charge a la direccion donde se mueve el jugador al apretar el boton 'run'
	if Input.is_action_pressed('run'):
		if direction != 0 and charge < 110:
			charge += 1
			anim.play('run')
	#sino camina
	else:
		if direction != 0:
			if charge > 0:
				charge -= 2
			anim.play('walk')
			
	#o se encuentra en idle
	if direction == 0:
		if charge > 0:
			charge -= 5
		anim.play('idle') 
	
	#invierte la animacion para simular derecha e izquierda
	if direction != 0:
		if direction > 0:
			anim.flip_h = false
		if direction < 0:
			anim.flip_h = true
		
	#aumenta la velocidad del jugador
	velocity.x = direction * (speed + (charge * 200)) * delta
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var objeto = collision.get_collider()
	
		if objeto.is_in_group("enemigo") and not muerto:
			morir()
	
	#verificaciones para saltar
	if is_on_floor():
		can_jump = true
	else:
		gravedad -= 25
	
	#verificamos que no se pueda saltar cuando se esta saltando y mientras mas se aprete el boton de saltar mas alto salta el jugador
	if Input.is_action_pressed('jump') and can_jump:
		if timerOn == false:
			timerOn = true
			$Timer.start()
		gravedad = 300
		anim.play('jump')
	
	if Input.is_action_just_released("jump"):
		can_jump = false
		
	
	velocity.y = -gravedad
	
	

#agregue el nodo timer para que la animacion del salto se mantenga mientras se este aprentando 'jump'
func _on_timer_timeout():
	can_jump = false
	timerOn = false
	
func morir():
	print("te moriste... me costo una banda hacer esto")
	muerto = true
	salud = 0
	get_tree().reload_current_scene()
