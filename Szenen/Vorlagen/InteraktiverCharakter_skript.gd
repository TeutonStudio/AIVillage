@tool
class_name InteraktiverCharakter
extends CharacterBody3D

@onready var kopf: Marker3D = $Kopf
@onready var blick: RayCast3D = %Blick
@onready var individuum: Individuum = %Individuum

@export_node_path("Marker3D") var lebensraum
@export var persönlichkeit: Persönlichkeit:
	set(wert): persönlichkeit = wert; self._aktualisiere_kopf()

@export_node_path("Zeit") var zeit

func _ready() -> void: if Engine.is_editor_hint(): pass
else:
	if not self.persönlichkeit: push_warning([self.name," wurde keine Persönlichkeit definiert"])
	self._verwalte_tageszeit()
	self._aktualisiere_kopf()

func _physics_process(delta: float) -> void: if Engine.is_editor_hint(): pass
else:
	self._bewege_kopf(delta)
	if self.blick.is_colliding():
		var objekt := self.blick.get_collider()

@export_storage var tageszeit: Zeit.TAGESZEIT
func _verwalte_tageszeit() -> void:
	var zeit := self.get_node(self.zeit) as Zeit
	zeit.tageszeit.connect(func(zeitraum: Zeit.TAGESZEIT) -> void:
		self.tageszeit = int(zeitraum)
	)

#region Kopf

func _bewege_kopf(delta: float) -> void:
	self.alt_fokus = lerp(self.alt_fokus,self.fokus,delta)
	self.kopf.look_at(self.alt_fokus)

func _vernichte_kopf() -> void: if self.kopf:
	var string := self.persönlichkeit._erhalte_kopfname()
	var kopf_alt := self.kopf.find_child(string)
	if kopf_alt: kopf_alt.free()

func _aktualisiere_kopf() -> void: if self.kopf:
	for __ in 2: self.schaue_nach(self.kopf.global_position + Vector3.FORWARD)
	self._vernichte_kopf()
	self.kopf.add_child(self.persönlichkeit.erhalte_kopf())

var alt_fokus: Vector3
var fokus: Vector3
func schaue_nach(fokus: Vector3) -> void:
	self.alt_fokus = self.fokus
	self.fokus = fokus

#endregion
#region Gespräch

var dialog: Dialog
func beginne_gespräch(
	gesprächspartner: StringName,
	dialog: Dialog,
) -> void:
	dialog.rede_antwort = []
	dialog.visible = true
	dialog.spitzname = self.persönlichkeit.spitzname
	dialog.propagiert.connect(
		self._on_dialog_propagiert,
		ConnectFlags.CONNECT_ONE_SHOT,
	)
	self.individuum.gedanken.system_prompt = self.persönlichkeit.erhalte_system_prompt()
	self.gesprächspartner = gesprächspartner
	self.dialog = dialog

var gesprächspartner: StringName
var antworten: Callable
func _on_dialog_propagiert(aussage: String) -> void:
	self.dialog.propagiert.connect(_on_dialog_propagiert,ConnectFlags.CONNECT_ONE_SHOT)
	if self.dialog.rede_antwort.size() < 2:
		self.antworten = self.individuum.ansprechen(
			aussage,self.gesprächspartner,self.dialog.antwortet,self.dialog._erweitere_dialog,
		)
	else: self.antworten.call(aussage)
func _on_dialog_abgeschlossen(gespräch: String) -> void:
	#self.dialog.propagiert.disconnect(_on_dialog_propagiert)
	
	self.dialog = null
	self.gesprächspartner = ""
	self.antworten = func(es): pass
	
	self.individuum.gedanken.say(Persönlichkeit.erhalte_gesprächs_abschluß_prompt(gespräch))
	self.individuum.gedanken.response_finished.connect(
		func(aussage: String) -> void:
			print(antworten),
		ConnectFlags.CONNECT_ONE_SHOT,
	)

#endregion
#region Sichtbar

@export_storage var sichtfeld: Array[CharacterBody3D]
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == self: return
	if body is InteraktiverCharakter: 
		self.sichtfeld.append(body)
		
		print([body.name," hat das Sichtfeld von ",self.name," betreten"])
	if body is Spieler: 
		self.sichtfeld.append(body)
		
		print([body.name," hat das Sichtfeld von ",self.name," betreten"])
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == self: push_warning(["wieso hat ",self.name," sein eigenes Sichtfeld verlassen?"])
	if body is InteraktiverCharakter: 
		if self.sichtfeld.has(body): self.sichtfeld.erase(body)
		
		print([body.name," hat das Sichtfeld von ",self.name," verlassen"])
	if body is Spieler: 
		if self.sichtfeld.has(body): self.sichtfeld.erase(body)
		
		print([body.name," hat das Sichtfeld von ",self.name," verlassen"])
	pass # Replace with function body.

#endregion
