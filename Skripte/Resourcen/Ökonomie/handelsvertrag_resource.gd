class_name Handelsvertrag
extends Vertrag

#@export var einkäufer: StringName
#@export var verkäufer: StringName
@export var preisliste: Array[float]
@export var warenkorb: Warenkorb

func erhalte_gesamtpreis() -> float:
	var ausgabe := .0
	for jedes: int in self.warenkorb.inhalt.size():
		ausgabe += self.preisliste[jedes]
	return ausgabe

func erhalte_einkäufer() -> StringName:
	return self.geber

func erhalte_verkäufer() -> StringName:
	return self.nehmer
