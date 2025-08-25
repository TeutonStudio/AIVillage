class_name Individuum
extends Resource

enum VERWANDSCHAFT {
	Sohn, Tochter,
	Bruder, Schwester,
	Vater, Mutter,
	Onkel, Tante,
	Großvater, Großmutter,
	Großonkel, Großtante,
}

@export_enum("weib","mann") var geschlecht: int
@export var spitzname: StringName
@export var stammbaum: Dictionary[Individuum.VERWANDSCHAFT,PackedStringArray]
@export var gesprächs_farbe: Color
@export var ökonomie: Ökonomie = null

func _ready() -> void:
	self.ökonomie = self.ökonomie if self.ökonomie else Ökonomie.new()
