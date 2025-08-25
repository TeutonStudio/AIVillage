class_name SpielerCharakter
extends CharacterBody3D

const WERTE := {
	"bewegung_todesradius":.15,
	"bewegung_geschwindigkeit":5.0,
	"hüpfen_kraft":4.5,
}

@onready var skeleton: Skeleton3D = %Skelett
@onready var kopf: Marker3D = %Kopf

@export var individuum: Interagierer

#region Eingabe

static func _erhalte_eingabe_bewegung() -> Vector2:
	return Input.get_vector(
		"bewegen_seitwärts_links","bewegen_seitwärts_rechts",
		"bewegen_vorwärts","bewegen_rückwärts",
	)
static func _erhalte_ist_kooperativ() -> bool:
	return Input.is_action_just_pressed("interaktion_kooperativ")

#endregion
#region Zustand

func _ist_laufend(
	eingabe_länge := SpielerCharakter._erhalte_eingabe_bewegung().length(),
) -> bool: return eingabe_länge > SpielerCharakter.WERTE["bewegung_todesradius"]

func _ist_sprechend() -> bool:
	return self.kopf.dialog.visible


#endregion

static func _move_toward(
	_richtung: Vector2,
	_velocity: Vector3,
	_transform: Transform3D,
	geschwindigkeit := SpielerCharakter.WERTE["bewegung_geschwindigkeit"],
	orientierung := (_transform.basis * Vector3(
		_richtung.x, 0, _richtung.y
	)).normalized(),
	ausgabe := Vector3(
		orientierung.x, 0,
		orientierung.z,
	) * geschwindigkeit if orientierung else Vector3(
		move_toward(_velocity.x,0,geschwindigkeit), 0,
		move_toward(_velocity.z,0,geschwindigkeit),
	)
) -> Vector3: ausgabe.y = _velocity.y; return ausgabe


func _physics_process(delta: float,
	eingabe := SpielerCharakter._erhalte_eingabe_bewegung(),
	springen := Input.is_action_just_pressed("ui_accept"),
	#winkel := self.global_rotation.y - self.kopf.global_rotation.y
) -> void: if not self._ist_sprechend():
	if not self.is_on_floor():
		self.velocity += self.get_gravity() * delta
	elif springen: 
		self.velocity.y = SpielerCharakter.WERTE["hüpfen_kraft"]
	
	self.velocity = self._move_toward(eingabe,self.velocity,self.transform)
	self.move_and_slide()


#func _on_dialog_dialog_abgeschlossen(dialog: String) -> void:
	#print(dialog)
	#for jedes: Dictionary in self.dialog.propagiert.get_connections():
		#jedes["signal"].disconnect(jedes["callable"])
	#
