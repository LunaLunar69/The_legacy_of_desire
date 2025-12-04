extends CharacterBody2D

# --- Variables Exportadas y Constantes ---
@export var SPEED: float = 200.0 # Velocidad configurable desde el Inspector
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Define los nombres de las animaciones que tienes en tu SpriteFrames:
const ANIM_WALK_BACK := "walkfront" # Para caminar hacia ARRIBA
const ANIM_WALK_FRONT := "walkback" # Para caminar hacia ABAJO
const ANIM_WALK_SIDE := "walkside" # Para caminar a los lados (usaremos flip_h para izquierda)
const ANIM_IDLE := "walkfront" # Usaremos la primera frame de "walkfront" para la inactividad

# --- Lógica de Movimiento ---

func _physics_process(delta: float) -> void:
	# 1. Obtener la entrada del usuario
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_vector != Vector2.ZERO:
		# Si hay movimiento, normalizamos y aplicamos velocidad
		velocity = input_vector.normalized() * SPEED
		
		# 2. Llamamos a la función para gestionar las animaciones
		_update_animations(input_vector)
	else:
		# Si no hay movimiento, detenemos la velocidad y establecemos la animación de inactividad
		velocity = Vector2.ZERO
		_update_idle_state()

	# 3. Mover el personaje
	move_and_slide()


# --- Función de Gestión de Animaciones ---

func _update_animations(input_vector: Vector2) -> void:
	# Comprobamos la dirección principal para decidir qué animación reproducir:
	
	if abs(input_vector.x) > abs(input_vector.y):
		# Movimiento Horizontal (Lados)
		animated_sprite.animation = ANIM_WALK_SIDE
		
		# Determinar la dirección horizontal y voltear el sprite (Flip H):
		if input_vector.x > 0:
			# Derecha
			animated_sprite.flip_h = false
		else:
			# Izquierda
			animated_sprite.flip_h = true
	
	else:
		# Movimiento Vertical (Arriba/Abajo)
		animated_sprite.flip_h = false # Quitamos el flip
		
		if input_vector.y > 0:
			# Abajo
			animated_sprite.animation = ANIM_WALK_FRONT
		else:
			# Arriba
			animated_sprite.animation = ANIM_WALK_BACK
			
	# Aseguramos que la animación se esté reproduciendo
	animated_sprite.play()


# --- Función para Inactividad ---

func _update_idle_state() -> void:
	# Si el personaje está inactivo, establecemos la animación IDLE.
	# Aquí usamos "walkfront" pero detenemos la reproducción
	if animated_sprite.animation != ANIM_IDLE:
		animated_sprite.animation = ANIM_IDLE
		
	# Detenemos la animación y forzamos el Frame 0 (posición de reposo)
	animated_sprite.stop()
	animated_sprite.frame = 0
