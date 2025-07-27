class_name Unterhaltung
extends Resource

@export_node_path("Zeit") var zeit: NodePath
@export_node_path("Dialog") var dialog: NodePath
@export var gesprächspartner: StringName
#@export var gesprächsteilnehmer: Array[Individuum]

func _init(
	zeit: NodePath = self.zeit,
	dialog: NodePath = self.dialog,
	gesprächspartner: StringName = self.gesprächspartner,
	#gesprächsteilnehmer: Array[Individuum] = self.gesprächsteilnehmer,
) -> void:
	self.gesprächspartner = gesprächspartner
	self.dialog = dialog
	self.zeit = zeit
	
	self.individuum.gedanken.system_prompt = self.persönlichkeit._erhalte_system_prompt()
	self.gesprächspartner = gesprächspartner

#var dialog: Dialog
#func beginne_gespräch(
	#gesprächspartner: StringName,
	#dialog: Dialog,
	#get_node: Callable,
#) -> void:
	#dialog.visible = true
	#dialog.spitzname = self.persönlichkeit.spitzname
	#get_node.call(self.zeit)
	#get_node.call(self.dialog)
	#self.individuum.gedanken.system_prompt = self.persönlichkeit._erhalte_system_prompt()
	#self.gesprächspartner = gesprächspartner

var antworten: Callable
func _on_dialog_propagiert(
	aussage: String,
	get_node: Callable,
) -> void:
	var _dialog_node := get_node.call(self.dialog) as Dialog
	_dialog_node.propagiert.connect(_on_dialog_propagiert,ConnectFlags.CONNECT_ONE_SHOT)
	if _dialog_node.rede_antwort.size() < 2:
		self.antworten = self.individuum.ansprechen(
			aussage,
			self.gesprächspartner,
			_dialog_node.antwortet,
			_dialog_node._erweitere_dialog,
		)
	else: self.antworten.call(aussage)
