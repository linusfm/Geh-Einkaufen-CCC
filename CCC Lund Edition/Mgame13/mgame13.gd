extends Node2D
var active = false
var spawn_ready = false
signal lost(paneln)
signal win(paneln)

@export var transition: PackedScene

### Internal Constants
var wagen_speed = 20
var ueberlappung_wagen_katzenfutter = false
var falling_dose = false
var im_wagen = false
var start_KF = Vector2(-5, -5)
### Variables

func set_active(b):
	active = b
	if active == true:
		$MusicPlayer.resume()
	else:
		$MusicPlayer.pause()
	
func new_game():
	$Katzenfutter/Sprite2DK.position = start_KF

func enable():
	if get_node("GameOver"):
		get_node("GameOver").despawn()
	spawn_ready = false
	new_game()

func disable(text, color):
	var trans = transition.instantiate()
	add_child(trans)
	trans.spawn(text, color)
	spawn_ready = true

func gamewon():
	disable("You survived!", Color(0, 0.5, 0, 0))
	win.emit(5)
	
func gamelost():
	disable("Signal Lost", Color(0.5, 0., 0, 0))
	lost.emit(5)

func _ready():
	pass
	var music = preload("res://music/mgame4.mp3")
	$MusicPlayer.start(music)



func _process(delta):
	if Input.is_action_just_pressed("newgame"):
		enable()
	if $Einkaufswagen.position.x > -30:
		if Input.is_action_pressed("Left") and active == true:
			$Einkaufswagen.position.x -= wagen_speed * delta
			if im_wagen == true:
				$Katzenfutter/Sprite2DK.position.x -= wagen_speed * delta
	if $Einkaufswagen.position.x < 25:
		if Input.is_action_pressed("Right") and active == true:
			$Einkaufswagen.position.x += wagen_speed * delta
			if im_wagen == true:
				$Katzenfutter/Sprite2DK.position.x += wagen_speed * delta
	if ueberlappung_wagen_katzenfutter:
		if Input.is_action_pressed("Down") and active == true: 
			falling_dose = true
	if ueberlappung_wagen_katzenfutter:
		if Input.is_action_pressed("Up") and active == true: 
			falling_dose = true
	if falling_dose == true:
		falling_dose = false
		var ziel_pos = Vector2($Einkaufswagen/Sprite2DE.position.x - 10, $Einkaufswagen/Sprite2DE.position.y - 10)
		if Input.is_action_pressed("Down") and active == true and im_wagen == false:
			$Katzenfutter/Sprite2DK.position = ziel_pos
			im_wagen = true 
		if Input.is_action_pressed("Up") and active == true and im_wagen == true:
			$Katzenfutter/Sprite2DK.position = start_KF
			im_wagen = false
			

func _on_katzenfutter_area_entered(area: Area2D):
	ueberlappung_wagen_katzenfutter = true
	print("ueberlappung_wagen_katzenfutter")

func _on_katzenfutter_area_exited(area: Area2D):
	ueberlappung_wagen_katzenfutter = false 
