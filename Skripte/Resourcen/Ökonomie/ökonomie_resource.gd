@tool
class_name Ökonomie
extends Resource

@export var ziel: Vector3
@export var inventar: Warenkorb
@export var währung: float = 0.0
@export var arbeitsverträge: Array[Arbeitsvertrag] = []
@export_group("Private Eigenschaften")
@export_range(0,100) var durst: float
@export_range(0,100) var hunger: float
@export_range(0,100) var dopamin: float
@export_group("Öffentliche Eigenschaften")
@export_range(0,100) var energie: float
@export_range(0,100) var hygiene: float

func erhalte_stimmungsprompt() -> String:
	
	return ""

func ist_lebendig(
	ist_verdurstet := self.durst >= 100,
	ist_verhungert := self.hunger >= 100,
	ist_vereinsamt := self.dopamin <= 0,
	ist_erschöpft := self.energie <= 0,
) -> bool: return not (
		ist_verdurstet or ist_erschöpft or 
		ist_verhungert or ist_vereinsamt
	)
