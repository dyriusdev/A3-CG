'''
Singleton principal do jogo
'''
extends Node

signal spawn(position : Vector3)

var mouse_sensitivity : float = 0.01

var danger_stage : int = 1 
