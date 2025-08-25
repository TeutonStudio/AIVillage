class_name Reagierer
extends Individuum

@export var persönlichkeit: Persönlichkeit


func _ready() -> void:
	self.persönlichkeit = self.persönlichkeit if self.persönlichkeit else Persönlichkeit.new()

func erhalte_system_prompt() -> String:
	var lebensgeschichte := self.persönlichkeit.erhalte_system_prompt(self.spitzname)
	
	return lebensgeschichte

@export_category("Intelligenz")
@export var sprachmodell: Sprachmodelle.MODELL

func erhalte_modellpfad() -> StringName:
	return Sprachmodelle.erhalte_modellpfad(self.sprachmodell)
