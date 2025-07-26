@tool
class_name Individuum
extends NobodyWhoModel

@onready var gedanken: NobodyWhoChat = $Gedanken
@onready var aufgaben: NobodyWhoEmbedding = $Aufgaben

func _ready() -> void: if Engine.is_editor_hint(): print("System Prompt wird außerhalb des Editors erzeugt")
else:
	if self.gedanken.system_prompt == "": push_warning("Persönlichkeit definieren")
	#self.gedanken.system_prompt = self._erhalte_system_prompt()
	self.aufgaben.embed("verabschiedung")



#func _erhalte_system_prompt() -> String:
	#var ausgabe := "Dein Spitzname lautet "+spitzname+". deine Erlebnisse waren: "
	#for jedes: String in self.lebensgeschichte: ausgabe += jedes
	#
	#return ausgabe

var dialog: String
func erweitere_dialog(
	fremdwort: String,
	eigenwort: String,
) -> void: if self.dialog == "":
	self.dialog = self._rede_antwort(fremdwort,eigenwort)
else: self.dialog = self.dialog+" die Reaktion war "+self._rede_antwort(eigenwort,fremdwort)

func _rede_antwort(
	fremdwort: String,
	eigenwort: String,
) -> String: return fremdwort+" du hast das Geantwortet "+eigenwort

func ansprechen(
	aussage: String,
	ansprecher: StringName,
	spricht: Callable,
	ausgesprochen: Callable,
) -> Callable:
	var prompt := """Du wirst von """+ansprecher+""" angesprochen, reagiere entsprechend der Meinung, 
		die sich aus deinen Erlebnissen mit ihm ergeben.
		Er sagt: """+aussage
	var response := func(antwort: String) -> void:
		ausgesprochen.call(antwort)
		self.erweitere_dialog(prompt,Dialog.remove_think_tags(antwort))
	self.gedanken.say(prompt+". Erzeuge nur deine Antwort.")
	self.gedanken.response_updated.connect(spricht)
	self.gedanken.response_finished.connect(response,CONNECT_ONE_SHOT)
	return func(antwort: String) -> void:
		var nächster_prompt := """Du führst ein Gespräch mit """+ansprecher+""" der bisherige Dialog lautet
		"""+self.dialog+""" nun hat er wie foglt reagiert """+antwort+""" führe den dialog fohrt."""
		self.gedanken.say(nächster_prompt+". Erzeuge nur deine Antwort.")
		self.gedanken.response_finished.connect(response,CONNECT_ONE_SHOT)


func _on_aufgaben_embedding_finished(embedding: PackedFloat32Array) -> void:
	var prompt := """ Evaluiere den folgenden Dialog, fasse die für dich nötigsten informationen 
	in eine Erzählung zusammen """+self.dialog
	self.gedanken.say(prompt)
	self.gedanken.response_finished.connect(func(antwort: String):
		self.lebensgeschichte.append(
			Dialog.remove_think_tags(antwort)
		)
	)
