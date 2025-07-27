class_name Spieler
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var kopf: MeshInstance3D = $Kopf
@onready var blick: RayCast3D = $Kopf/Blick
@onready var dialog: Dialog = %Dialog

@export var spitzname: StringName

@export var maus_gefangen: bool:
	get: return Input.mouse_mode == Input.MouseMode.MOUSE_MODE_CAPTURED
	set(wert): if wert: Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
	else: Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE


static func _erhalte_eingabe_bewegung() -> Vector2:
	return Input.get_vector(
		"bewegen_seitwärts_links","bewegen_seitwärts_rechts",
		"bewegen_vorwärts","bewegen_rückwärts",
	)
static func _erhalte_kooperativ() -> bool:
	return Input.is_action_just_pressed("interaktion_kooperativ")

static func _move_toward(
	richtung: Vector2,
	velocity: Vector3,
	transform: Transform3D
) -> Vector3:
	var orientierung := (transform.basis * Vector3(richtung.x, 0, richtung.y)).normalized()
	var ausgabe := Vector3(
		orientierung.x,
		0,
		orientierung.z,
	) * Spieler.SPEED if orientierung else Vector3(
		move_toward(velocity.x,0,Spieler.SPEED),
		0,
		move_toward(velocity.z,0,Spieler.SPEED),
	); ausgabe.y = velocity.y
	return ausgabe

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not self.dialog.visible:
			if event.pressed: self.maus_gefangen = true
	if event is InputEventMouseMotion:
		if not self.dialog.visible:
			self.rotate_y(event.relative.x * .025)
			self.kopf.rotation.x = clampf(
				self.kopf.rotation.x + event.relative.y * .025,
				deg_to_rad(-30),deg_to_rad(15),
			)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): self.maus_gefangen = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not self.is_on_floor():
		self.velocity += self.get_gravity() * delta
	
	var begutachtet := self.blick.is_colliding() and not self.dialog.visible
	if begutachtet: self._betrachtet(self.blick.get_collider())
	
	if not self.dialog.visible:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and self.is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		
		var input_dir := Spieler._erhalte_eingabe_bewegung()
		self.velocity = self._move_toward(input_dir,self.velocity,self.transform)
		
		self.move_and_slide()


func _betrachtet(objekt: Object) -> void:
	if objekt is InteraktiverCharakter:
		if Spieler._erhalte_kooperativ():
			self.spricht = true
			self.maus_gefangen = false
			objekt.schaue_nach(self.kopf.global_position)
			objekt.beginne_gespräch(self.spitzname,self.dialog)

func _on_dialog_dialog_abgeschlossen(dialog: String) -> void:
	print(dialog)
	for jedes: Dictionary in self.dialog.propagiert.get_connections():
		jedes["signal"].disconnect(jedes["callable"])
	
