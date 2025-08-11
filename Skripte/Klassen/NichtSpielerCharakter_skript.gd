@tool
class_name NichtSpielerCharakter
extends CharacterBody3D

enum VERHALTENSZUSTAND {
	Beschäftigt,
	Erfolg, Debakel,
	Unbeschäftigt,
}

@onready var kopf: Marker3D = %Kopf
@onready var wegfinder: NavigationAgent3D = %Wegfinder
@onready var skelett: Skeleton3D = %Skelett

@export_node_path("ÖkonomischeRealität") var marktzeit
@export var individuum: Reagierer

@export_storage var beschäftigt := false

func _ready() -> void: if Engine.is_editor_hint(): pass
	#if not self.bewusstsein: self.bewusstsein = Bewusstsein.new()
else:
	if self.get_parent() is ÖkonomischeRealität:
		self.marktzeit = self.get_parent().get_path()
	if not self.individuum: 
		push_warning([self.name," hat keine Selbstständigkeit"])
	else: self.individuum._ready()
	#self._verwalte_tageszeit()
	#self._aktualisiere_kopf()

#func _physics_process(delta: float) -> void: if Engine.is_editor_hint(): pass
#else:
	#self.kopf._bewege_kopf(delta)
	##self._bewege(delta)
	#if self.blick.is_colliding(): 
		#self.kopf._betrachtet(self.blick.get_collider())

@export_storage var zustand: NichtSpielerCharakter.VERHALTENSZUSTAND
#func erhalte_verhalten() -> ÖkonomischerCharakter3D.VERHALTENSZUSTAND:
	#var ausgabe := self.zustand
	#if self.zustand in [
		#ÖkonomischerCharakter3D.VERHALTENSZUSTAND.Erfolg,
		#ÖkonomischerCharakter3D.VERHALTENSZUSTAND.Debakel
	#]: self.zustand = ÖkonomischerCharakter3D.VERHALTENSZUSTAND.Unbeschäftigt
	#return ausgabe

##region Betrachtet
#
#func _betrachtet(objekt: Object) -> void: 
	#if objekt is CollisionShape3D: pass
	#if objekt is CSGPrimitive3D: pass
#
##endregion 
#region Zeit

func _erhalte_marktzeit() -> ÖkonomischeRealität:
	return self.get_node(self.marktzeit)
func _erhalte_zeitpunkt() -> Zeitpunkt:
	return self._erhalte_marktzeit().zeit.zeitpunkt
func erhalte_datum() -> String:
	return self._erhalte_zeitpunkt().erhalte_datum()

#var aktualisiere_zeitdaten: Callable
#@export_storage var datum: String:
	#get: return self.zeitpunkt.erhalte_datum()
#@export_storage var zeitpunkt: Zeitpunkt:
	#get: return self._erhalte_marktzeit().zeit.zeitpunkt
#func _verwalte_tageszeit() -> void:
	#var marktzeit := self.get_node(self.marktzeit) as ÖkonomischeRealität
	
	#marktzeit.aktualisieren = func():
		#self.uhrzeit = marktzeit.erhalte_uhrzeit()
		#self.wochentag = marktzeit.erhalte_wochentag()

#endregion 
##region Zeitplan
#
#@export_storage var arbeitstag: bool:
	#get: if self.arbeitstage: 
		#var tagesindex := Zeit.WOCHENTAG.keys().find(self.wochentag)
		#return self.arbeitstage.has(tagesindex)
	#else: return false
#TODO Dictionary[Zeit.WOCHENTAG,Arbeitszeiten]
#@export var arbeitstage: Array[Zeit.WOCHENTAG]
#func muss_arbeiten_gehen() -> String: 
	#var ist_arbeitstag := self.arbeitstage.has(self.wochentag)
	#var ist_arbeitszeit := true # TODO - arbeitswegzeit
	#return "08:00"
#
##endregion 
#region Raum

func erhalte_abstand(zu: Vector3) -> float:
	self.wegfinder.target_position = zu
	return self.wegfinder.distance_to_target()

#func gehe(nach: StringName) -> void:
	#var pfad := self.lokalisationen[nach]
	#var objekt := self.get_node(pfad) as Lebensraum
	#var umgebung := objekt.umgebung
	#if nach == "Zuhause": 	self._gehe_zu(objekt)
	#if nach == "Arbeit": 	self._gehe_zu(objekt)
	#if nach == "Kantine": 	self._gehe_zu(objekt)
#func _gehe(wohin: Vector3) -> void: self.bewusstsein.ziel = wohin
#var geschwindigkeit := 2.0
#var beschleunigung := 3.0
#func _bewege(
	#delta: float,
	#nach := self.bewusstsein.ziel,
#) -> void: if nach:
	#if self.global_position.distance_to(nach) < .3: return
	#self.wahrnehmung.target_position = nach
	#var zwischenziel := self.wahrnehmung.get_next_path_position()
	#var richtung := zwischenziel - self.global_position
	#self.look_at(richtung)
	#self.velocity = self.velocity.lerp(
		#richtung * self.geschwindigkeit,
		#self.beschleunigung * delta,
	#); self.move_and_slide()
#func _gehe_zu(lebensraum: Lebensraum) -> void: if lebensraum:
	#self.bewusstsein.ziel = lebensraum.erhalte_sammelpunkt()
##@export_storage var aufenthalt: InteraktiverCharakter.LOKALISATION
#func _verwalte_lokalisation(lebensraum: Lebensraum) -> void:
	#var liste := self.lokalisationen.values().map(func(es: NodePath):
		#return (self.get_node(es) as Lebensraum).name
	#); self.aufenthalt = liste.find(lebensraum.name)

#endregion 
##region Kopf
#
#func _bewege_kopf(delta: float) -> void:
	#self.alt_fokus = lerp(self.alt_fokus,self.fokus,delta)
	##self.kopf.look_at(self.alt_fokus)
#
#var alt_fokus: Vector3
#var fokus: Vector3
#func schaue_nach(fokus: Vector3) -> void:
	#self.alt_fokus = self.fokus
	#self.fokus = fokus
#
##endregion
#region Gespräch

#var dialog: Gespräch
func beginne_gespräch(
	gesprächspartner: StringName,
	gespräch: Gespräch,
) -> Unterhaltung:
	self.gesprächspartner = gesprächspartner
	gespräch.visible = true
	return Unterhaltung.new(
		[gesprächspartner,self.individuum.spitzname],{
			self.individuum.spitzname: self.individuum
		}
	)

#var gesprächspartner: StringName
#var antworten: Callable
#func _on_dialog_propagiert(aussage: String) -> void:
	#self.dialog.propagiert.connect(_on_dialog_propagiert,ConnectFlags.CONNECT_ONE_SHOT)
	#if self.dialog.rede_antwort.size() < 2:
		#self.antworten = self.individuum.ansprechen(
			#aussage,self.gesprächspartner,self.dialog.antwortet,self.dialog._erweitere_dialog,
		#)
	#else: self.antworten.call(aussage)
#func _on_dialog_abgeschlossen(gespräch: String) -> void:
	##(self.get_node(self.zeit) as Zeit).fließt = true
	#
	#self.dialog = null
	#self.gesprächspartner = ""
	#self.antworten = func(es): pass
	#
	#self.individuum.gedanken.say(Persönlichkeit.erhalte_gesprächs_abschluß_prompt(gespräch))
	#self.individuum.gedanken.response_finished.connect(
		#func(aussage: String) -> void:
			#print(antworten),
		#ConnectFlags.CONNECT_ONE_SHOT,
	#)

#endregion
