extends CharacterBody2D

@export var speed: float = 80.0
@export var change_direction_time: float = 1.2

# Intensidad del temblor
@export var camera_shake_amount: float = 6.0

var direction := Vector2.ZERO
var timer := 0.0

@onready var anim = $AnimatedSprite2D
@onready var step_sound = $AudioStreamPlayer2D
@onready var camera : Camera2D = get_viewport().get_camera_2d()

var shake_time := 0.0


func _process(delta):
	# Cambiar dirección cada cierto tiempo
	timer -= delta
	if timer <= 0:
		direction = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		).normalized()
		timer = change_direction_time

	velocity = direction * speed
	move_and_slide()

	update_animation(direction)
	update_sound(direction)
	#update_camera_shake(delta)


# -----------------------------
# ANIMACIÓN SEGÚN DIRECCIÓN
# -----------------------------
func update_animation(dir: Vector2):
	if dir == Vector2.ZERO:
		anim.play("left")
		return

	if abs(dir.x) > abs(dir.y):
		anim.play("left")
		anim.flip_h = dir.x > 0
		return

	anim.flip_h = false

	if dir.y > 0:
		anim.play("down")
	else:
		anim.play("up")


# -----------------------------
# SONIDO DE PASOS
# -----------------------------
func update_sound(dir: Vector2):
	if dir == Vector2.ZERO:
		step_sound.stop()
		return

	#if not step_sound.playing:
		#step_sound.play()
#
	## Activamos el temblor
	#shake_time = 0.1


# -----------------------------
# TEMBLOR DE CÁMARA
# -----------------------------

#func update_camera_shake(delta):
	#if not camera:
		#return
#
	#if shake_time > 0:
		#shake_time -= delta
#
		#camera.offset = Vector2(
			#randf_range(-camera_shake_amount, camera_shake_amount),
			#randf_range(-camera_shake_amount, camera_shake_amount)
		#)
	#else:
		#camera.offset = Vector2.ZERO
