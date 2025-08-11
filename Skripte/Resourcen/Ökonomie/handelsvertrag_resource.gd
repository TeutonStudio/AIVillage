class_name Handelsvertrag
extends Vertrag

@export var einkäufer: StringName
@export var verkäufer: StringName
@export var preisliste: Array[float]
@export var warenkorb: Warenkorb
@export var zeitpunkt: Zeitpunkt

func erhalte_gesamtpreis() -> float:
	var ausgabe := .0
	for jedes: int in self.warenkorb.inhalt.size():
		ausgabe += self.preisliste[jedes]
	return ausgabe
