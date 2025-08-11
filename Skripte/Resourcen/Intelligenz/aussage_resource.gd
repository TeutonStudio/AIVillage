@tool
class_name Aussage
extends Resource

signal neuer_inhalt(inhalt: String)

const TEXTUREN := [
	preload("res://Symbole/user.png"),
	preload("res://Symbole/man.png"),
	preload("res://Symbole/woman.png"),
] 

func _init(
	propagant := self.propagant,
	empfänger := self.empfänger,
	inhalt := self.inhalt,
	pic := self.pic,
	farbe := self.farbe,
) -> void:
	self.propagant = propagant
	self.empfänger = empfänger
	self.inhalt = inhalt
	self.pic = pic
	self.farbe = farbe

@export_enum("unbekannt","männlich","weiblich") var pic: int
@export var farbe: Color
@export var propagant: StringName
@export var empfänger: StringName
@export_multiline var inhalt: String:
	set(wert): inhalt = wert; self.neuer_inhalt.emit(wert)


static func entferne_gedanken(
	str: String,
	start_tag := "<think>",
	end_tag := "</think>",
) -> String:
	var start_idx = str.find(start_tag)
	
	while start_idx != -1:
		var end_idx = str.find(end_tag)
		if end_idx == -1: break
		end_idx += end_tag.length()
		str = str.substr(0, start_idx) + str.substr(end_idx)
		start_idx = str.find(start_tag)
	
	return str
