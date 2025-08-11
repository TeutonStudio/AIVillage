class_name Zeitpunkt
extends Resource

const minuten_je_stunde := 60
const stunden_je_tag := 24
const tage_je_woche := 7
const wochen_je_jahr := 53
const maximale_jahre := 1024

@export_range(0,Zeitpunkt.minuten_je_stunde) var minute: int
@export_range(0,Zeitpunkt.stunden_je_tag) var stunde: int
@export_range(0,Zeitpunkt.tage_je_woche) var tage: int
@export_range(0,Zeitpunkt.wochen_je_jahr) var woche: int
@export_range(0,Zeitpunkt.maximale_jahre) var jahre: int

func _init(
	minute := self.minute,
	stunde := self.stunde,
	tage := self.tage,
	woche := self.woche,
	jahre := self.jahre,
) -> void:
	self.minute = minute
	self.stunde = stunde
	self.tage = tage
	self.woche = woche
	self.jahre = jahre

func setze_auf_tick(ticks: int) -> void:
	var einheit := Zeit.erhalte_zeiteinheit.bind(ticks)
	var uhr := self.erhalte_uhrzeit(ticks).split(":")
	self.minute = int(uhr[0])
	self.stunde = int(uhr[1])
	self.tage = einheit.call(Zeit.ZEITEINHEIT.Tage)
	self.woche = einheit.call(Zeit.ZEITEINHEIT.Wochen)
	self.jahre = einheit.call(Zeit.ZEITEINHEIT.Jahre)

func erhalte_uhrzeit(
	ticks: float,
	tage := Zeit.erhalte_zeiteinheit(Zeit.ZEITEINHEIT.Tage,ticks),
	tageszeit := tage - int(tage),
) -> String:
	var stunden := 24 * float(tageszeit)
	var minuten := 60 * float(stunden - int(stunden))
	return Zeitpunkt._erhalte_uhrzeit(int(stunden),int(minuten))

func verschiebe(um: Zeitpunkt, minus := false) -> void:
	var einheiten := {
		"minute": Zeitpunkt.minuten_je_stunde,
		"stunde": Zeitpunkt.stunden_je_tag,
		"tage": Zeit.WOCHENTAG.size(),
		"woche": Zeitpunkt.wochen_je_jahr,
		"jahre": Zeitpunkt.maximale_jahre,
	} as Dictionary[StringName,int]
	for idx: int in einheiten.size():
		var index := einheiten.size() - idx if minus else idx
		var index2 := index - (1 if minus else -1)
		var andere := einheiten.keys()[index2] as StringName
		var einheit := einheiten.keys()[index] as StringName
		if not andere: andere = "2^10_jahre" if minus else "2^10_jahre"
		self.set(
			andere,self.get(andere) + self._verschiebe_rück(
			einheit,um.get(einheit),einheiten[einheit]
		))
func _verschiebe_vor(
	variable: String,
	um: float, grenze: int,
) -> int:
	var neue_einheit := self.get(variable) + um as int
	self.set(variable,neue_einheit)
	if neue_einheit > grenze:
		self.set(variable,neue_einheit % grenze)
		return int(neue_einheit / grenze)
	return 0
func _verschiebe_rück(
	variable: String,
	um: float, grenze: int,
) -> int:
	var neue_einheit := self.get(variable) - um as int
	if neue_einheit < 0:
		self.set(variable,neue_einheit+grenze)
		return -1
	self.set(variable,neue_einheit)
	return 0


func _set(eigenschaft: StringName, wert: Variant) -> bool:
	#if eigenschaft == "2^10_jahre":
	if eigenschaft == "2^10_jahre":
		push_warning("Nicht auf Suchtis ausgelegt")
	return false

func erhalte_datum() -> String:
	return Zeitpunkt._erhalte_datum(
		self.minute,
		self.stunde,
		self.tage,
		self.woche,
		self.jahre,
	)
static func _erhalte_datum(
	_minute: int, _stunde: int,
	_tage: int, _woche: int,
	_jahre: int,
) -> String: return " ".join([
	Zeitpunkt._erhalte_uhrzeit(_stunde,_minute),
	"am",Zeitpunkt._erhalte_wochentag(_tage),"zur",
	_woche,"Woche des Jahres",_jahre
])

static func _erhalte_uhrzeit(stunden: int,minuten: int) -> String:
	return "%02d:%02d" % [stunden,minuten]

static func _erhalte_wochentag(tag: int) -> String:
	return Zeit.WOCHENTAG.keys()[tag]
