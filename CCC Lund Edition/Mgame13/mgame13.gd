extends Node2D
var active = false
var spawn_ready = false
signal lost(paneln)
signal win(paneln)

@export var transition: PackedScene

### Internal Constants
var wagen_speed = 20
var ueberlappung_wagen_katzenfutter = false
var ueberlappung_wagen_hundefutter1 = false
var im_wagen = false
var falling_dose = ""
var inhalt = ""
var start_KF = Vector2(-5, -5)
var start_HF1 = Vector2(10,-5)
### Variables

func set_active(b):
	active = b
	if active == true:
		$MusicPlayer.resume()
	else:
		$MusicPlayer.pause()
	
func new_game():
	$Katzenfutter/Sprite2DK.position = start_KF
	$Hundefutter1/Sprite2DH1.position = start_HF1

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
			if inhalt == "KF":
				$Katzenfutter/Sprite2DK.position.x -= wagen_speed * delta
			if inhalt == "HF1":
				$Hundefutter1/Sprite2DH1.position.x -= wagen_speed * delta
	if $Einkaufswagen.position.x < 25:
		if Input.is_action_pressed("Right") and active == true:
			$Einkaufswagen.position.x += wagen_speed * delta
			if inhalt == "KF":
				$Katzenfutter/Sprite2DK.position.x += wagen_speed * delta
			if inhalt == "HF1":
				$Hundefutter1/Sprite2DH1.position.x += wagen_speed * delta
	if ueberlappung_wagen_katzenfutter:
		if Input.is_action_pressed("Down") and active == true: 
			falling_dose = "KF"
	if ueberlappung_wagen_katzenfutter:
		if Input.is_action_pressed("Up") and active == true: 
			falling_dose = "KF"
	if ueberlappung_wagen_hundefutter1:
		if Input.is_action_pressed("Down") and active == true: 
			falling_dose = "HF1"
	if ueberlappung_wagen_hundefutter1:
		if Input.is_action_pressed("Up") and active == true: 
			falling_dose = "HF1"
	if falling_dose == "KF":
		falling_dose = ""
		if Input.is_action_pressed("Down") and active == true and inhalt == "":
			$Katzenfutter/Sprite2DK.position = Vector2(-5,16)
			inhalt = "KF"
		if Input.is_action_pressed("Up") and active == true and inhalt == "KF":
			$Katzenfutter/Sprite2DK.position = start_KF
			inhalt = ""
	if falling_dose == "HF1":
		falling_dose = ""
		var ziel_pos = $Einkaufswagen/Sprite2DE.position
		if Input.is_action_pressed("Down") and active == true and inhalt == "":
			$Hundefutter1/Sprite2DH1.position = Vector2(10,16)
			inhalt = "HF1"
		if Input.is_action_pressed("Up") and active == true and inhalt == "HF1":
			$Hundefutter1/Sprite2DH1.position = start_HF1
			inhalt = ""

func _on_katzenfutter_area_entered(area: Area2D):
	ueberlappung_wagen_katzenfutter = true
	print("ueberlappung_wagen_katzenfutter")

func _on_katzenfutter_area_exited(area: Area2D):
	ueberlappung_wagen_katzenfutter = false 


func _on_hundefutter_1_area_entered(area: Area2D):
	ueberlappung_wagen_hundefutter1 = true
	print("ueberlappung_wagen_hundefutter1")


func _on_hundefutter_1_area_exited(area: Area2D):
	ueberlappung_wagen_hundefutter1 = false
