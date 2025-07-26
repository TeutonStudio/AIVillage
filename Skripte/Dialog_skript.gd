@tool
class_name Dialog
extends Control

signal propagiert(aussage: String)


@onready var button: Button = $PanelContainer/MarginContainer/VBoxContainer/HSplitContainer/Button
@onready var line_edit: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/HSplitContainer/LineEdit
@onready var rich_text_label: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/RichTextLabel



var rede_antwort: Array[String] = []:
	set(wert):
		rede_antwort = wert
		self._erzeuge_dialog()

func _erzeuge_dialog() -> void:
	self._vernichte_dialog()
	for jedes: String in self.rede_antwort:
		self.rich_text_label.append_text(self.remove_think_tags(jedes)+"\n")
	self.line_edit.text = ""
	self.button.disabled = false

func antwortet(reaktion: String) -> void:
	self.rich_text_label.append_text(reaktion)

func _vernichte_dialog() -> void:
	self.rich_text_label.text = ""

static func remove_think_tags(text: String) -> String:
	var start_tag = "<think>"
	var end_tag = "</think>"
	var start_idx = text.find(start_tag)
	var end_idx = text.find(end_tag)
	
	if start_idx != -1 and end_idx != -1 and start_idx < end_idx:
		var result = text.substr(0, start_idx) + text.substr(end_idx + end_tag.length())
		return result.strip_edges()
	
	return text.strip_edges()

func _on_button_pressed() -> void:
	var eingabe = self.line_edit.text
	if eingabe != "":
		self.button.disabled = true
		self.rede_antwort.append(eingabe)
		self.propagiert.emit(self.line_edit.text)
