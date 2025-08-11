@tool
class_name Lebensraum
extends Marker3D

@export var umgebung: Umgebung


var gebiet: Area3D = null
#var sp: Marker3D = null
var anwesende: Dictionary[StringName,Individuum]

func ist_anwesend(body: ÖkonomischerCharakter3D) -> bool: 
	return self.anwesende.has(body.individuum)

func erhalte_sammelpunkt() -> Vector3:
	return self.sp.global_position

func _ready() -> void:
	self._erzeuge_gebiet()
	#self._erzeueg_sammelpunkt()

#const sp_str := "Sammelpunkt"
#func _erzeueg_sammelpunkt() -> void:
	#self.sp = self.find_child(Lebensraum.sp_str)
	#if not self.sp: self.sp = Marker3D.new(); self.add_child(self.sp)
	#self.sp.name = Lebensraum.sp_str
	#self.sp.set_owner( self.get_tree().edited_scene_root )

const gebiet_str := "Gebiet"
func _erzeuge_gebiet() -> void:
	self.gebiet = self.find_child(Lebensraum.gebiet_str)
	if not self.gebiet: self.gebiet = Area3D.new(); self.add_child(self.gebiet)
	self.gebiet.name = Lebensraum.gebiet_str
	self.gebiet.body_entered.connect( self._on_area_3d_body_entered )
	self.gebiet.body_exited.connect( self._on_area_3d_body_exited )
	self.gebiet.set_owner( self.get_tree().edited_scene_root )


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is ÖkonomischerCharakter3D:
		body._verwalte_lokalisation(self)
		self.anwesende[body.individuum.spitzname] = body.individuum

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is ÖkonomischerCharakter3D:
		self.anwesende[body.individuum.spitzname] = null
