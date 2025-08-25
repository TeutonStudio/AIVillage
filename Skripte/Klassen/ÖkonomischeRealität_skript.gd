@tool
class_name ÖkonomischeRealität
extends Node

# Zentrale Verwaltung ökonomierelevanter Ressourcen
@export var zeit: Zeit
@export var markt: Markt


func _ready() -> void:
	# Initialisierung und ggf. Verknüpfung der Ressourcen
	if not self.zeit:	 self.zeit = Zeit.new()
	if not self.markt:	 self.markt = Markt.new(
		self.erhalte_alle_marktwesen()
	)

func erhalte_alle_marktwesen() -> Array[Individuum]:
	var marktwesen := [] as Array[Individuum]
	for jedes in self.get_children():
		if jedes is NichtSpielerCharakter:
			marktwesen.append(jedes.individuum)
	return marktwesen

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	# Zeit-Ticks aktualisieren und Zeitpunkt synchronisieren
	if zeit and zeit.fließt:
		zeit.aktualisere_ticks(delta)

	# Beispiel: Markttransaktionen könnten hier mit Zeitstempel versehen werden
	# (Logik für Transaktionen etc. erfolgt in den jeweiligen Ressourcen)
