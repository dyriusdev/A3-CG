'''
Singleton principal do jogo
'''
extends Node

@warning_ignore("unused_signal")
signal collected_keys

var mouse_sensitivity : float = 0.01

var keys : int = 0
var to_collect : int = 8

var danger_factor : float = 0.1
