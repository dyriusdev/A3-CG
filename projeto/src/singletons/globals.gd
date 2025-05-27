'''
Singleton principal do jogo
'''
extends Node

@warning_ignore("unused_signal")
signal game_over
@warning_ignore("unused_signal")
signal collected_keys
@warning_ignore("unused_signal")
signal seeing_monster(flag : bool)

var mouse_sensitivity : float = 0.01

var keys : int = 0
var to_collect : int = 8

var danger_factor : float = 0.1

# Aplicar impulso ao colidir com objetos do tipo rigbody
func apply_objects_impulse(body : CharacterBody3D) -> void:
	for i in body.get_slide_collision_count():
		var collider : KinematicCollision3D = body.get_slide_collision(i)
		if collider.get_collider() is RigidBody3D:
			collider.get_collider().apply_central_impulse(-collider.get_normal() * 0.5)
	pass
