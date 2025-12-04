extends CharacterBody2D

# --- PROPIEDADES DE MOVIMIENTO Y EFECTOS ---
@export var speed: float = 80.0
@export var change_direction_time: float = 1.2
@export var camera_shake_amount: float = 6.0

# --- PROPIEDADES DE JUEGO ---
const WIN_SCENE_PATH = "res://Escenas/PantallaGanar.tscn" # <--- ¡AJUSTA ESTA RUTA!

# --- VARIABLES DE ESTADO Y NODOS ---
var is_dead: bool = false
var direction := Vector2.ZERO
var timer := 0.0 # Timer para el cambio de dirección
var shake_time := 0.0 # Timer para el temblor de cámara

@onready var anim = $AnimatedSprite2D
@onready var camera : Camera2D = get_viewport().get_camera_2d()


# --- INICIALIZACIÓN ---

func _ready():
	# Agregamos La Gorda al grupo "enemies" para que Chad la pueda identificar
	add_to_group("enemies")
	
	# Inicializamos el timer para el primer movimiento
	timer = change_direction_time

# --- LÓGICA PRINCIPAL (MOVIMIENTO Y ANIMACIÓN) ---

func _process(delta):
	if is_dead: # ¡Si está muerta, salir inmediatamente!
		return

	# 1. Lógica de Cambio de Dirección Aleatoria
	timer -= delta
	if timer <= 0:
		direction = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		).normalized()
		timer = change_direction_time

	velocity = direction * speed
	move_and_slide()

	# 2. Actualización Visual y de Sonido
	update_animation(direction)
	update_sound(direction)
	# update_camera_shake(delta) # Descomenta si usas la lógica de temblor

# --- FUNCIONES DE MUERTE Y TRANSICIÓN ---

# Esta función es llamada por el script de Chad al golpearla
func take_hit_and_die() -> void:
	if is_dead:
		return 

	is_dead = true
	
	# Detenemos completamente toda la lógica de Gorda
	set_process(false) 
	set_physics_process(false)
	
	
	# Reproducir la animación de "death"
	anim.play("death") 
	
	# Conectamos la señal para cambiar de escena al terminar la animación
	if not anim.animation_finished.is_connected(_on_death_animation_finished):
		anim.animation_finished.connect(_on_death_animation_finished)

func _on_death_animation_finished() -> void:
	# Solo cambiamos de escena si la animación que terminó es la de muerte
	if anim.animation == "death":
		# Cambiar a la escena "Win"
		print("Ganar")
		var error = get_tree().change_scene_to_file(WIN_SCENE_PATH)
		
		if error != OK:
			print("ERROR: No se pudo cargar la escena de victoria. Revisa la ruta: ", WIN_SCENE_PATH)

# --- FUNCIONES DE UTILIDAD ---
 
func update_animation(dir: Vector2):
	if dir == Vector2.ZERO:
		anim.play("left") # Animación IDLE (asumo "left" es el idle frontal)
		return

	if abs(dir.x) > abs(dir.y):
		anim.play("left") # Animación lateral
		anim.flip_h = dir.x > 0
		return

	anim.flip_h = false

	if dir.y > 0:
		anim.play("down")
	else:
		anim.play("up")

func update_sound(dir: Vector2):
	if dir == Vector2.ZERO:
		return

	#if not step_sound.playing:
		#step_sound.play()

# func update_camera_shake(delta):
# 	if not camera:
# 		return
# 
# 	if shake_time > 0:
# 		shake_time -= delta
# 
# 		camera.offset = Vector2(
# 			randf_range(-camera_shake_amount, camera_shake_amount),
# 			randf_range(-camera_shake_amount, camera_shake_amount)
# 		)
# 	else:
# 		camera.offset = Vector2.ZERO
