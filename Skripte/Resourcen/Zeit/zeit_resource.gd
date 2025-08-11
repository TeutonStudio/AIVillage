class_name Zeit
extends Resource

# Zeiteinheiten für Tick-Berechnung und Zeitlogik
enum ZEITEINHEIT {
	Tage,
	Wochen,
	Jahre,
}

enum WOCHENTAG {
	Montag,
	Dienstag,
	Mittwoch,
	Donnerstag,
	Freitag,
	Samstag,
	Sonntag,
}

enum JAHRESWOCHEN {
	KW01,KW02,KW03,KW04,KW05,KW06,KW07,KW08,KW09,KW10,
	KW11,KW12,KW13,KW14,KW15,KW16,KW17,KW18,KW19,KW20,
	KW21,KW22,KW23,KW24,KW25,KW26,KW27,KW28,KW29,KW30,
	KW31,KW32,KW33,KW34,KW35,KW36,KW37,KW38,KW39,KW40,
	KW41,KW42,KW43,KW44,KW45,KW46,KW47,KW48,KW49,KW50,
	KW51,KW52,
}

const ticks_je_sek := 10


@export var fließt := true
@export var ticks: int
@export_storage var zeitpunkt: Zeitpunkt

func _init() -> void: self.zeitpunkt = Zeitpunkt.new()

# Gibt die Tick-Anzahl für die gewünschte Zeiteinheit zurück
static func _definition(einheit: ZEITEINHEIT) -> int:
	match einheit:
		ZEITEINHEIT.Tage:
			return 60 * 60
		ZEITEINHEIT.Wochen:
			return Zeit._definition(ZEITEINHEIT.Tage) * Zeit.WOCHENTAG.size()
		ZEITEINHEIT.Jahre:
			return Zeit._definition(ZEITEINHEIT.Wochen) * Zeit.JAHRESWOCHEN.size()
		_: return 0

static func erhalte_zeiteinheit(einheit: ZEITEINHEIT, ticks: float) -> float:
	return ticks / Zeit._definition(einheit)

func aktualisere_ticks(delta: float) -> void:
	if self.fließt:
		self.ticks += delta * Zeit.ticks_je_sek
		self.zeitpunkt.setze_auf_tick(self.ticks)

# Parst einen Datum-String im Format wie von Zeitpunkt._erhalte_datum erzeugt und gibt ein Zeitpunkt-Objekt zurück
static func erhalte_zeitpunkt(datum: StringName) -> Zeitpunkt:
	# Erwartetes Format: 'HH:MM am <Wochentag> zur <Woche> Woche des Jahres <Jahr>'
	var teile := datum.split(" ")
	if teile.size() < 8:
		push_error("Ungültiges Datumsformat: %s" % datum)
		return null
	var uhrzeit := teile[0].split(":")
	
	return Zeitpunkt.new(
		int(uhrzeit[1]), 
		int(uhrzeit[0]), 
		Zeit.WOCHENTAG.keys().find(teile[2]), 
		Zeit.JAHRESWOCHEN.keys().find(teile[4]), 
		int(teile[7]),
	)
