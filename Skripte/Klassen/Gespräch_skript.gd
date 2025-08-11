@tool
class_name Gespräch
extends Control

signal gespräch_abgeschlossen(gespräch: String)

@onready var verabschieden: Button = %Verabschieden
@onready var gespräch: VBoxContainer = %Gesprächsinhalt
@onready var antwort: LineEdit = %Antwort
@onready var sprechen: Button = %Sprechen
@onready var sprachmodell: NobodyWhoModel = %Sprachmodell


@export var unterhaltung: Unterhaltung


func ist_aktiv() -> bool: return not self.visible

func _vernichte_dialog() -> void:
	for jedes in self.gespräch.get_children(): jedes.free()

func _gesprächsverlauf_aktualisieren() -> void:
	self._vernichte_dialog()
	self.unterhaltung.erzeuge_dialog(self.gespräch)


func _on_verabschieden_pressed(
	#gesprächsverlauf := self._erstelle_gesprächsverlauf()
) -> void:
	#gespräch_abgeschlossen.emit(gesprächsverlauf)
	self.visible = false
	if unterhaltung: unterhaltung.beende_gespräch()

func _on_sprechen_pressed(
	propagant := self.unterhaltung.gesprächsteilnehmer[0],
	empfänger := self.unterhaltung.gesprächsteilnehmer[1],
	on_fertig := func() -> void: 
		self.sprechen.disabled = false
		self.antwort.text = ""
) -> void:
	if self.antwort.text == "": return
	if self.unterhaltung: self.unterhaltung.antworte(
		Aussage.new(
			propagant,empfänger,
			self.antwort.text,0,
			Color.WHITE,
		), sprachmodell, 
		self.gespräch, on_fertig,
	); self.sprechen.disabled = true
	self._gesprächsverlauf_aktualisieren()
