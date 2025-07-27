@tool
class_name Persönlichkeit
extends Resource

enum VERWANDSCHAFT {
	Bruder, Schwester,
	Vater, Mutter,
	Onkel, Tante,
	Großvater, Großmutter,
	Großonkel, Großtante,
}

const kopf: Array[PackedScene] = [
	preload("res://Grauboxung/x_person_graubox.scn"),
	preload("res://Grauboxung/y_person_graubox.scn"),
]

@export var gesprächs_farbe: Color
@export_enum("x","y") var geschlecht: int
@export var spitzname: StringName
@export var stammbaum: Dictionary[Persönlichkeit.VERWANDSCHAFT,PackedStringArray]
@export var freundschaften: PackedStringArray
@export_multiline var lebensgeschichte: Array[String]

func _erhalte_kopfname() -> StringName: return spitzname+"_kopf"

func erhalte_kopf() -> Node3D:
	var kopf := self.kopf[self.geschlecht].instantiate()
	kopf.name = self._erhalte_kopfname()
	return kopf

func erhalte_system_prompt() -> String:
	var ausgabe := """Mein Name lautet """+self.spitzname+"."
	if not self.stammbaum.is_empty():
		ausgabe += """Meine Familienverhältnisse sind wie folgt: """
		for jedes: Persönlichkeit.VERWANDSCHAFT in self.stammbaum.keys(): 
			var relation := Persönlichkeit.VERWANDSCHAFT.find_key(jedes) as String
			var verwandte := self.stammbaum[jedes]
			for jeden: String in verwandte:
				ausgabe += jeden+" ist zu mir mein "+relation+"., "
	if not self.freundschaften.is_empty():
		ausgabe += """Meine freunde sind: """
		for jedes: String in self.freundschaften:
			ausgabe += jedes+", "
	if not self.lebensgeschichte.is_empty():
		ausgabe += """Meine Geschichte setzt sich aus den folgenden Erreignissen zusammen: """
		for jedes in self.lebensgeschichte:
			ausgabe += jedes+", "
	
	return ausgabe

static func erhalte_gesprächs_abschluß_prompt(gespräch: String) -> String:
	return "Aus dem folgendem Dialog fasst du die für dich notwendigen Informationen zussammen: "+gespräch
