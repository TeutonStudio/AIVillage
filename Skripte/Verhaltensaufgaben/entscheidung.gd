@tool
class_name Entscheidung
extends BTComposite


# Task parameters.
#@export var parameter1: float
#@export var parameter2: Vector2

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.
const VERHALTENSZUSTAND = NichtSpielerCharakter.VERHALTENSZUSTAND

func erhalte_zustand() -> Entscheidung.VERHALTENSZUSTAND:
	return self.agent.zustand as Entscheidung.VERHALTENSZUSTAND

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "MyDecision"


## Called to initialize the task.
#func _setup() -> void:
	#pass


# Called when the task is entered.
func _enter(
	unbeschätigt := Entscheidung.VERHALTENSZUSTAND.Unbeschäftigt
) -> void:
	if self.erhalte_zustand() == unbeschätigt:
		pass
		# TODO Verhaltensabfrage


# Called when the task is exited.
func _exit() -> void:
	self.agent.zustand = Entscheidung.VERHALTENSZUSTAND.Unbeschäftigt

## Called each time this task is ticked (aka executed).
#func _tick(delta: float) -> Status:
	#match self.erhalte_zustand():
		#ÖkonomischerCharakter3D.VERHALTENSZUSTAND.Beschäftigt:
			#return BT.Status.RUNNING
		#ÖkonomischerCharakter3D.VERHALTENSZUSTAND.Erfolg:
			#return BT.Status.SUCCESS
		#ÖkonomischerCharakter3D.VERHALTENSZUSTAND.Debakel:
			#return BT.Status.FAILURE
		#
		#_: return BT.Status.FRESH
#



# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
