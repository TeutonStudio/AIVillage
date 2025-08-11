@tool
class_name GesprächsPart
extends MarginContainer


#@onready var panel: PanelContainer = %PanelContainer
#@onready var texture: TextureRect = %Grafikfeld
#@onready var label: Label = %Namensfeld
#@onready var text_label: RichTextLabel = %Textfeld

@export var aussage: Aussage:
	set(wert): if wert: aussage = self._definiere(wert)

func _ist_fertig() -> bool:
	return %PanelContainer and %Grafikfeld and %Namensfeld and %Textfeld

func _definiere(
	wert: Aussage, aufgabe := self._definiere_aussage.bind(wert)
) -> Aussage: if self._ist_fertig():
	aufgabe.call(wert.inhalt)
	wert.neuer_inhalt.connect(aufgabe)
	return wert
else: return null

func _definiere_aussage(
	inhalt: String, aussage: Aussage,
) -> void:
	self._definiere_pic(aussage.pic)
	self._definiere_text(inhalt)
	self._setzte_namen(aussage.propagant)
	self._definiere_farbe(aussage.farbe)

func _definiere_pic(wert: int) -> void:
	%Grafikfeld.texture = Aussage.TEXTUREN[wert]

func _definiere_text(wert: String) -> void:
	%Textfeld.text = Aussage.entferne_gedanken(wert)

func _setzte_namen(wert: String) -> void:
	%Namensfeld.text = "\n".join(wert.split(" "))

func _definiere_farbe(wert: Color) -> void:
	if not self._ist_fertig(): print([%PanelContainer,%Grafikfeld,%Namensfeld,%Textfeld])
	%PanelContainer.get_theme_stylebox("panel").bg_color = wert
	%Namensfeld.label_settings.font_color = wert.inverted()
	%Textfeld.add_theme_color_override("default_color",wert.inverted())
	#.label_settings.font_color = wert.inverted()
