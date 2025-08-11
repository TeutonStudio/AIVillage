class_name Warenkorb
extends Resource

@export var inhalt: Array[Ware]

func enthält(ware: StringName) -> bool:
	return inhalt.map(func(es): return es.name).has(ware)
