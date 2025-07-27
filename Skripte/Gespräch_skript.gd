class_name Gespräch
extends Control

signal propagiert(aussage: String)

@onready var panel_container: PanelContainer = $PanelContainer
@onready var button_verabschieden: Button = $PanelContainer/MarginContainer/VBoxContainer/Button


@onready var button_propagieren: Button = $PanelContainer/MarginContainer/VBoxContainer/HSplitContainer/Button
@onready var line_edit: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/HSplitContainer/LineEdit
@onready var rich_text_label: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/RichTextLabel


@export var farbe: Color:
	set(wert): farbe = wert; self._aktualisere_panel(wert)

func _aktualisere_panel(
	_farbe: Color = self.farbe
) -> void: if self.panel_container:
	var panel := StyleBoxFlat.new()
	panel.bg_color = _farbe
	panel.shadow_size = 10
	panel.set_corner_radius_all(25)
	self.panel_container.add_theme_stylebox_override("panel",panel)

var rede_antwort: Array = []

func antwortet(reaktion: String) -> void:
	self.rich_text_label.append_text(reaktion)

func _vernichte_dialog() -> void:
	self.rede_antwort = []
	self.rich_text_label.text = ""

func _entbinde_propagierung() -> void:
	for jedes: Dictionary in self.propagiert.get_connections():
		jedes["signal"].disconnect(jedes["callable"])

static func remove_think_tags(text: String) -> String:
	var start_tag = "<think>"
	var end_tag = "</think>"
	var start_idx = text.find(start_tag)
	var end_idx = text.find(end_tag)
	
	if start_idx != -1 and end_idx != -1 and start_idx < end_idx:
		var result = text.substr(0, start_idx) + text.substr(end_idx + end_tag.length())
		return result.strip_edges()
	
	return text.strip_edges()

func _on_button_propagieren_pressed() -> void:
	var eingabe = self.line_edit.text
	if eingabe != "":
		self.button_propagieren.disabled = true
		self.rede_antwort.append(eingabe)
		self.propagiert.emit(self.line_edit.text)
