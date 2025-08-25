class_name Arbeitsvertrag
extends Vertrag

#@export var arbeitgeber: StringName
#@export var arbeitnehmer: StringName
@export var arbeitszeiten: Array[Zeitraum]
@export var wochenlohn: int

func erhalte_arbeitgeber() -> StringName:
	return self.geber

func erhalte_arbeitnehmer() -> StringName:
	return self.nehmer
