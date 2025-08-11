class_name Ware
extends Resource

enum KATEGORIE {
	Nahrung,
	Getränke, 
	Kleidung, 
	Rohstoffe,
}

@export var name: StringName
@export var eigenschaften: Array[Ware.KATEGORIE]
@export_multiline var beschreibung: String

func _init(
	name := self.name
) -> void:
	self.name = name

func _get_property_list() -> Array[Dictionary]:
	var ausgabe := [] as Array[Dictionary]

	if self.eigenschaften.has(Ware.KATEGORIE.Nahrung):
		ausgabe.append_array([{
			"name": "Nährwert",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,100,1",
			"category": "Nahrung",
		},{
			"name": "Haltbarkeit",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,100,1",
			"category": "Nahrung",
		}])
	if self.eigenschaften.has(Ware.KATEGORIE.Getränke):
		ausgabe.append({
			"name": "Trinkwert",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,100,1",
			"category": "Getränke",
		})
	if self.eigenschaften.has(Ware.KATEGORIE.Kleidung):
		ausgabe.append_array([{
			"name": "Schnitt",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "Unterwäsche,Schlüpfer,Milchtütenhalter,Hose,Hemd,Rock,Bluse,Anzug,Kleid",
			"category": "Kleidung",
		},{
			"name": "Schutzwert",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,100,1",
			"category": "Kleidung",
		},{
			"name": "Haltbarkeit",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,100,1",
			"category": "Kleidung",
		}])
	if self.eigenschaften.has(Ware.KATEGORIE.Rohstoffe):
		ausgabe.append_array([{}]) # TODO Rezept für Rohstoffe
	

	return ausgabe
