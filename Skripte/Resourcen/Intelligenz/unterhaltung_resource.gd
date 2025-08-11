class_name Unterhaltung
extends Resource


@export var individuen: Dictionary[StringName,Individuum]
@export var gesprächsteilnehmer: Array[StringName]

func _init(
	_gesprächsteilnehmer: Array[StringName] = self.gesprächsteilnehmer,
	_individuen: Dictionary[StringName,Individuum] = self.individuen,
) -> void:
	self.gesprächsteilnehmer = _gesprächsteilnehmer
	self.individuen = _individuen

@export_storage var verlauf: Array[Aussage]

func antworte(
	aussage: Aussage, model: NobodyWhoModel,
	vater: Control, on_fertig: Callable,
	chat := model.get_child(0) as NobodyWhoChat,
	individuum := self.individuen[aussage.empfänger],
	nächste_aussage := Aussage.new(
		aussage.empfänger,
		aussage.propagant,
		"",
		aussage.pic,
		aussage.farbe
	), denken := func(antwort: String) -> void: 
		nächste_aussage.inhalt += antwort,
) -> void:
	self.verlauf.append(aussage); self._erzeuge_propaganda(vater,aussage)
	self.verlauf.append(nächste_aussage)
	chat.system_prompt = individuum.erhalte_system_prompt()
	chat.response_updated.connect(denken)
	chat.response_finished.connect(func(antwort: String) -> void:
		nächste_aussage.inhalt = antwort
		chat.response_updated.disconnect(denken)
		on_fertig.call()
		print([antwort,nächste_aussage])
	,ConnectFlags.CONNECT_ONE_SHOT
	); chat.say(aussage.inhalt)

func erzeuge_dialog(
	vater: Control
) -> Control:
	for aussage: Aussage in self.verlauf:
		self._erzeuge_propaganda(vater,aussage)
	
	return vater

const aussage_vorlage := preload("res://Szenen/Benutzeroberfläche/aussage_vorlage.scn")
func _erzeuge_propaganda(
	vater: Control, aussage: Aussage,
	neue_aussage: GesprächsPart = Unterhaltung.aussage_vorlage.instantiate()
) -> void: 
	neue_aussage.aussage = aussage
	vater.add_child(neue_aussage)

func beende_gespräch(
	
) -> void: pass
