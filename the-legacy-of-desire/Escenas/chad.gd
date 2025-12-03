extends CharacterBody2D

const SPEED := 200.0  # Ajusta la velocidad a lo que se sienta bien para tu RPG

func _physics_process(delta: float) -> void:
	# Obtenemos el vector de entrada en 2D (izquierda/derecha, arriba/abajo)
	# Puedes usar "ui_left", "ui_right", "ui_up", "ui_down" o tus propias acciones.
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_vector != Vector2.ZERO:
		# Normalizamos para que en diagonal no se mueva más rápido
		input_vector = input_vector.normalized()
		velocity = input_vector * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
