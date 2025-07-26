class_name Persönnlichkeit
extends Resource

enum VERWANDSCHAFT {
	Bruder, Schwester,
	Vater, Mutter,
	Onkel, Tante,
	Großvater, Großmutter,
	Großonkel, Großtante,
}

@export var spitzname: StringName
@export_multiline var lebensgeschichte: Array[String]
@export var stammbaum: Dictionary[Persönnlichkeit.VERWANDSCHAFT,PackedStringArray]
@export var freundschaften: PackedStringArray

func _erhalte_system_prompt() -> String:
	return ""
