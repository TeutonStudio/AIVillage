class_name Spieler
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var kopf: MeshInstance3D = $Kopf
@onready var blick: RayCast3D = $Kopf/Blick
@onready var dialog: Dialog = %Dialog

@export var spitzname: StringName


static func _erhalte_eingabe_bewegung() -> Vector2:
	return Input.get_vector(
		"bewegen_seitwärts_links","bewegen_seitwärts_rechts",
		"bewegen_vorwärts","bewegen_rückwärts",
	)
static func _erhalte_kooperativ() -> bool:
	return Input.is_action_just_pressed("interaktion_kooperativ")


@export var maus_gefangen: bool:
	get: return Input.mouse_mode == Input.MouseMode.MOUSE_MODE_CAPTURED
	set(wert): if wert: Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
	else: Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE

#static func _is_in_range(wert,min,max) -> bool: return min < wert and wert < max

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not self.dialog.visible:
			if event.pressed: self.maus_gefangen = true
	if event is InputEventMouseMotion:
		if not self.spricht:
			self.rotate_y(event.relative.x * .025)
			self.kopf.rotation.x = clampf(
				self.kopf.rotation.x + event.relative.y * .025,
				deg_to_rad(-30),deg_to_rad(15),
			)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): self.maus_gefangen = false

var spricht: bool = false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not self.is_on_floor():
		self.velocity += self.get_gravity() * delta
	
	var begutachtet := self.blick.is_colliding() and not self.spricht
	if begutachtet: self._betrachtet(self.blick.get_collider())
	
	if not self.spricht:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and self.is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Spieler._erhalte_eingabe_bewegung()
		#var direction := (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		self.velocity = self._move_toward(input_dir)
		#if direction:
			#self.velocity.x = direction.x * SPEED
			#self.velocity.z = direction.z * SPEED
		#else:
			#self.velocity.x = move_toward(velocity.x, 0, SPEED)
			#self.velocity.z = move_toward(velocity.z, 0, SPEED)
		
		self.move_and_slide()

func _move_toward(
	richtung: Vector2,
) -> Vector3:
	var orientierung := (self.transform.basis * Vector3(richtung.x, 0, richtung.y)).normalized()
	return Vector3(
		orientierung.x,
		self.velocity.y,
		orientierung.z,
	) * Spieler.SPEED if orientierung else Vector3(
		move_toward(self.velocity.x,0,Spieler.SPEED),
		self.velocity.y,
		move_toward(self.velocity.z,0,Spieler.SPEED),
	)

func _betrachtet(objekt: Object) -> void:
	if objekt is InteraktiverCharakter:
		if Spieler._erhalte_kooperativ():
			self.spricht = true
			self.maus_gefangen = false
			objekt.schaue_nach(self.kopf.global_position)
			objekt.beginne_gespräch(self.spitzname,self.dialog)

func _on_dialog_dialog_abgeschlossen(dialog: String) -> void:
	self.spricht = false
	print(dialog)
	for jedes: Dictionary in self.dialog.propagiert.get_connections():
		jedes["signal"].disconnect(jedes["callable"])
	
