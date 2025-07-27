class_name Zeit 
extends Node

signal tageszeit(zeitraum: Zeit.TAGESZEIT)

enum TAGESZEIT {
	Morgen,
	Vormittag,
	Mittag,
	Nachmittag,
	Abend,
	Nacht,
}
enum ZEITEINHEIT {
	Tage
}

@export var fließt: bool = false
@export var tick_je_sek := 10
@export var einheitsdefinition: Dictionary[Zeit.ZEITEINHEIT,int] = {
	Zeit.ZEITEINHEIT.Tage:3600,
}

@export_storage var zeit: int


func _process(delta: float) -> void: if fließt: 
	zeit += delta * self.tick_je_sek
	var tage := float(zeit) / self.einheitsdefinition[Zeit.ZEITEINHEIT.Tage]
	var rel := tage - int(tage)
	if rel < .5:
		if rel < .1: self.tageszeit.emit(Zeit.TAGESZEIT.Morgen)
		if rel < .2: self.tageszeit.emit(Zeit.TAGESZEIT.Vormittag)
		if rel < .3: self.tageszeit.emit(Zeit.TAGESZEIT.Mittag)
		if rel < .4: self.tageszeit.emit(Zeit.TAGESZEIT.Nachmittag)
		if rel < .5: self.tageszeit.emit(Zeit.TAGESZEIT.Abend)
	else: self.tageszeit.emit(Zeit.TAGESZEIT.Nacht)

func _erhalte_zeiteinheit(einheit: Zeit.ZEITEINHEIT) -> float:
	return float(zeit) / self.einheitsdefinition[einheit]

func _erhalte_tageszeit() -> Zeit.TAGESZEIT:
	return Zeit.TAGESZEIT.Mittag
	pass
