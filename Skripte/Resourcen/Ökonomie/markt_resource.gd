class_name Markt
extends Resource

@export var teilnehmer: Array[Individuum]
@export_storage var geschäfte: Dictionary[String,Handelsvertrag]

func _init(
	teilnehmer := self.teilnehmer
) -> void:
	self.teilnehmer = teilnehmer

func tauschgeschäft(
	handel: Handelsvertrag, zeit: Zeit,
) -> void: self.geschäfte[zeit.erhalte_datum()] = handel

func _handel(handel: Dictionary[StringName,Variant]):
	var einkäufer := handel["einkäufer"] as StringName
	var verkäufer := handel["verkäufer"] as StringName
	var warenkorb := handel["warenkorb"] as Warenkorb

func erhalte_waren_verhältnis(
	ware1: Ware, ware2: Ware,
) -> float:
	
	return .0
func erhalte_warenkorb_verhältnis(
	warenkorb1: Warenkorb, warenkorb2: Warenkorb,
) -> float:
	
	return .0

func _erhalte_geschäfte(zr: Zeitraum) -> Array[Dictionary]:
	var ausgabe := [] as Array[Dictionary]
	for datum: StringName in self.geschäfte.keys():
		var zp := Zeit.erhalte_zeitpunkt(datum)
		if zr.innerhalb(zp):
			var handel := self.geschäfte[datum]
			ausgabe.append(handel)
	return ausgabe

func erhalte_warenpreis(
		ware: StringName, 
		zeitraum: Zeitraum,
) -> int:
	var gesamtpreis := 0
	for handel in self._erhalte_geschäfte(zeitraum):
		var warenkorb := handel["warenkorb"] as Warenkorb
		if warenkorb.enthält(ware): gesamtpreis += warenkorb.erhalte_warenpreis(ware)
	return gesamtpreis
