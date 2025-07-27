@tool
class_name Gruppenlog
extends Gespräch

signal gespräch_abgeschlossen(gespräch: String)

@export var beteiligte: PackedStringArray:
	set(wert): beteiligte = wert; self._aktualisiere_beteiligte(wert)

func _ready() -> void: self._aktualisere_panel()

func _aktualisiere_beteiligte(
	_beteiligte: PackedStringArray = self.beteiligte
) -> void: if self.button_verabschieden: 
	self.button_verabschieden.text = "Das Gespräch mit "
	for jedes in _beteiligte: self.button_verabschieden.text += jedes
	self.button_verabschieden.text += " beenden"

func _erzeuge_dialog() -> void:
	self._vernichte_dialog()
	for jedes: PackedStringArray in self.rede_antwort:
		self.rich_text_label.append_text(
			jedes[0]+":"+"\n"+"\t"+self.remove_think_tags(jedes[1])
		)
	self.line_edit.text = ""
	self.button_propagieren.disabled = false

func _on_button_verabschieden_pressed() -> void:
	print("Gespräch beendet")
	var gespräch := "Geführtes Gespräch: "
	for jedes: PackedStringArray in self.rede_antwort:
		gespräch += jedes[1]+": "+jedes[1]+" - "
	gespräch += self.line_edit.text
	self.gespräch_abgeschlossen.emit(gespräch)
	self.visible = false
	self.rede_antwort = []
