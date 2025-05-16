'''
Singleton principal do jogo
'''
extends Node

signal collected_page

var mouse_sensitivity : float = 0.01

var pages : int = 0
var to_collect : int = 8

var danger_factor : float = 0.1
