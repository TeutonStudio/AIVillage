@tool
class_name Dialog
extends Gespräch

signal dialog_abgeschlossen(dialog: String)

@export var spitzname: StringName:
	set(wert): spitzname = wert; self._aktualisiere_spitznamen(wert)

func _ready() -> void: self._aktualisere_panel()

func _aktualisiere_spitznamen(
	_spitzname: StringName = self.spitzname
) -> void: if self.button_verabschieden: 
	self.button_verabschieden.text = "Das Gespräch mit "+_spitzname+" beenden"

func _erweitere_dialog(antwort:String) -> void:
	self.rede_antwort += [antwort]
	self._erzeuge_dialog()

func _erzeuge_dialog() -> void:
	self.rich_text_label.text = ""
	for jedes: String in self.rede_antwort:
		self.rich_text_label.append_text(self.remove_think_tags(jedes)+"\n")
	self.line_edit.text = ""
	self.button_propagieren.disabled = false

func _on_button_verabschieden_pressed() -> void:
	print("Gespräch beendet")
	var dialog := "Geführter Dialog: "
	for jedes: String in self.rede_antwort:
		dialog += jedes+" - "
	dialog += self.line_edit.text
	self._entbinde_propagierung()
	self._vernichte_dialog()
	self.dialog_abgeschlossen.emit(dialog)
	self.visible = false
