extends Area2D

# --- Variables de Configuración ---
@export var move_speed: float = 100.0 # Velocidad del Slime
@export var movement_time: float = 2.0 # Tiempo en segundos que se moverá en una dirección

# --- Nodos ---
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Variable para guardar la dirección actual de movimiento
var current_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# 1. Conexión de señales (¡Es crucial!)
	
	# Conecta la señal 'body_entered' a la función _on_body_entered.
	# 'body_entered' se dispara cuando un Body (como tu CharacterBody2D de Chad) entra al área.
	body_entered.connect(_on_body_entered)
	
	# Conecta la señal 'timeout' del Timer a la función _on_timer_timeout.
	timer.timeout.connect(_on_timer_timeout)
	
	# 2. Configuración inicial del Timer y movimiento
	timer.wait_time = movement_time
	timer.start() # Empieza el temporizador
	_set_random_direction() # Empieza a moverse inmediatamente

# --- Lógica de Movimiento ---

func _physics_process(delta: float) -> void:
	# Movemos el Slime. Usamos 'position' porque es un Area2D.
	position += current_direction * move_speed * delta

func _set_random_direction() -> void:
	# Genera un nuevo vector de dirección aleatorio y lo normaliza
	var new_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	current_direction = new_direction
	
	# Opcional: Aquí puedes poner la lógica de animación para que se vea que camina
	if current_direction != Vector2.ZERO:
		animated_sprite.play("default")
	else:
		animated_sprite.play("default")


# --- Detección y Consecuencias ---

# Función llamada cuando el Timer se agota
func _on_timer_timeout() -> void:
	# Cuando el tiempo se acaba, cambiamos de dirección y reiniciamos el Timer
	_set_random_direction()
	timer.start()

# Función que se llama cuando Chad toca al Slime
func _on_body_entered(body: Node2D) -> void:
	# Verificamos si el objeto que entró es un 'CharacterBody2D' (que es el tipo de Chad)
	if body is CharacterBody2D:
		print("¡Slime tocó a Chad! Cambiando a la escena de menú.")
		
		# ⚠️ CAMBIO DE ESCENA: Manda el juego a la escena del menú
		var menu_scene_path = "res://menu.tscn" 
		
		# Asegúrate de que esta ruta (res://menu.tscn) sea la correcta para tu menú.
		if FileAccess.file_exists(menu_scene_path):
			get_tree().change_scene_to_file(menu_scene_path)
		else:
			# Si Godot no encuentra la ruta, imprime un error.
			print("ERROR: No se encontró el archivo de escena del menú en la ruta: " + menu_scene_path)
