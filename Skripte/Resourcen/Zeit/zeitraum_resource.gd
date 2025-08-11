class_name Zeitraum
extends Resource

@export var start: Zeitpunkt
@export var ende: Zeitpunkt

func _init(
	start := self.start,
	ende := self.ende,
) -> void:
	self.start = start
	self.ende = ende

func innerhalb(zp: Zeitpunkt) -> bool:
	# TODO liegt zp nach self.start aber vor self.ende?
	return false

func verändere_nach_hinten(länge: Zeitpunkt) -> void:
	# TODO self.ende so verschieben, dass self.länge() = länge
	pass
func verändere_nach_vorne(länge: Zeitpunkt) -> void:
	# TODO self.start so verschieben, dass self.länge() = länge
	pass

func länge() -> Zeitpunkt: return Zeitraum._länge(self.start,self.ende)
static func _länge(
	start: Zeitpunkt, ende: Zeitpunkt,
) -> Zeitpunkt: 
	var ausgabe := ende.duplicate() as Zeitpunkt
	ausgabe.verschiebe(start,true)
	return ausgabe
