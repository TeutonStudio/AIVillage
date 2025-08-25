@tool
class_name Persönlichkeit
extends Resource


@export var freundschaften: PackedStringArray
@export_multiline var tagesgeschichte: Array[String]
@export_multiline var wochengeschichte: Array[String]
@export_multiline var jahresgeschichte: Array[String]
@export_multiline var lebensgeschichte: Array[String]


func erhalte_system_prompt(name: StringName) -> String:
	var ausgabe := [
		"Dein Name lautet",name,
	]; self._schreibe_lebensgeschichte(ausgabe)
	
	return " ".join(ausgabe)

func _schreibe_lebensgeschichte(ausgabe: Array) -> void:
	var dict := {
		self.freundschaften:"Deine Freunde sind:",
		self.tagesgeschichte:"Dein letzter Tag setzt sich aus den folgenden Erreignissen zusammen:",
		self.wochengeschichte:"Deine letzte Woche setzt sich aus den folgenden Erreignissen zusammen:",
		self.jahresgeschichte:"Dein letztes Jahr setzt sich aus den folgenden Erreignissen zusammen:",
		self.lebensgeschichte:"Deine Lebensgeschichte setzt sich aus den folgenden Erreignissen zusammen:",
	}; for jedes in dict: Persönlichkeit._erweitere_geschichte(
		ausgabe,dict[jedes],jedes,
	)

static func _erweitere_geschichte(
	geschichte: Array,
	titel: String, abschnitte: Array,
) -> void: if not abschnitte.is_empty():
	geschichte.append(titel)
	for jedes in abschnitte: 
		geschichte.append_array([jedes,","])

static func erhalte_gesprächs_abschluß_prompt(gespräch: String) -> String:
	return "Aus dem folgendem Dialog fasst du die für dich notwendigen Informationen zussammen: "+gespräch
