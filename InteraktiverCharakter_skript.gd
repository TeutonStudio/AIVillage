class_name InteraktiverCharakter
extends CharacterBody3D

@onready var dialog: Dialog = $Kopf/Dialog
@onready var individuum: Individuum = $Kopf/Individuum
#@onready var gespräch: MeshInstance3D = $Kopf/Gespräch
@onready var blick: RayCast3D = $Kopf/Blick
#@onready var interagierbar: StaticBody3D = $Kopf/Interagierbar


@export var persönlichkeit: Persönnlichkeit



func _ready() -> void:
	if not self.persönlichkeit: push_warning([self.name," wurde keine Persönnlichkeit definiert"])
	self.individuum.gedanken.system_prompt = self.persönlichkeit._erhalte_system_prompt()
	self.dialog.visible = false

func _physics_process(delta: float) -> void:
	if self.blick.is_colliding():
		var objekt := self.blick.get_collider()
		#print(objekt)

func beginne_gespräch(
	gesprächspartner: StringName,
) -> void:
	self.dialog.visible = true
	self.gesprächspartner = gesprächspartner

var gesprächspartner: StringName
var antworten: Callable
func _on_dialog_propagiert(aussage: String) -> void:
	if self.dialog.rede_antwort.size() < 2:
		self.antworten = self.individuum.ansprechen(
			aussage,self.gesprächspartner,self.dialog.antwortet,func(antwort:String) -> void:
				self.dialog.rede_antwort += [antwort]
		)
	else: self.antworten.call(aussage)
