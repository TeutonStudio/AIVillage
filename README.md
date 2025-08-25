# AI Village

AI Village ist ein Godot-Projekt, das eine KI-gesteuerte Simulationsumgebung für Agenten bietet. Das Projekt nutzt Godot 4 und verschiedene GDExtensions, um komplexe KI-Logik, Aufgaben und Interaktionen zu ermöglichen.

## Projektstruktur

- `project.godot` – Godot-Projektdatei
- `addons/` – Erweiterungen und externe Module
  - `limboai/` – KI-Framework (mit Binärdateien, Icons, Dokumentation)
  - `nobodywho/` – GDExtension für zusätzliche KI-Funktionalität (verschiedene Plattform-Bibliotheken)
  - `orchestrator/` – Erweiterung zur Orchestrierung von KI-Agenten
- `Grauboxung/` – Test- und Platzhalterszenen
- `Skripte/` – GDScript-Skripte für Dialoge, Individuen, Lebensraum, Zeit, Ressourcen etc.
- `Szenen/` – Weitere Szenen und Vorlagen

## Hauptfunktionen

- **KI-Agenten**: Verschiedene Agententypen mit individuellen Verhaltensbäumen und Aufgaben.
- **GDExtensions**: Native Erweiterungen für Performance und komplexe KI-Logik (z.B. orchestrator, nobodywho).
- **Modularität**: Erweiterbar durch eigene Aufgaben, Bäume und Skripte.

## Installation & Nutzung

1. Godot 4.x installieren
2. Projekt in Godot öffnen (`project.godot`)
3. Abhängigkeiten prüfen (GDExtensions für das eigene Betriebssystem vorhanden?)
## Zeit-Klasse

Die Klasse `Zeit` steuert die Zeitmechanik im Spiel. Sie verwaltet die aktuelle Zeit, unterstützt verschiedene Zeiteinheiten (Tage, Wochen) und berechnet Tageszeit, Uhrzeit und Wochentag. Die Zeit kann kontinuierlich fortschreiten (`fließt`), wobei pro Tick die Zeit fortgeschrieben und ein Aktualisierungs-Callback aufgerufen wird. Die Klasse bietet Methoden zur Umrechnung und Formatierung von Zeitwerten und ist zentral für tageszeitabhängige Logik.

**Wichtige Funktionen:**
- Fortschreiben der Zeit im Spielprozess
- Umrechnung zwischen Zeiteinheiten (Tage, Wochen)
- Ermittlung und Formatierung der aktuellen Uhrzeit
- Export von Zeitwerten für andere Klassen
## Interaktiver Charakter

Die Klasse `InteraktiverCharakter` repräsentiert einen steuerbaren oder KI-gesteuerten Charakter im Spiel. Sie verwaltet Lokalisierungen (z.B. Zuhause, Arbeit, Kantine), besitzt Referenzen auf Wahrnehmung, Persönlichkeit und Zeit, und kann mit der Umgebung interagieren. Die Klasse steuert Bewegungen, Blickverhalten und Tagesabläufe und kann auf andere Charaktere reagieren.

**Wichtige Funktionen:**
- Verwaltung von Aufenthaltsorten und Lokalisierungen
- Integration mit der Zeitklasse für tageszeitabhängiges Verhalten
- Wahrnehmung und Interaktion mit anderen Charakteren
- Verwaltung von Persönlichkeit und Bewusstsein
## Lebensraum

Die Klasse `Lebensraum` modelliert einen Bereich oder Raum, in dem sich Charaktere aufhalten können. Sie erweitert `Marker3D` und verwaltet ein Gebiet (`Area3D`). Charaktere, die das Gebiet betreten, werden als anwesend registriert und können den Sammelpunkt als Ziel ansteuern.

**Wichtige Funktionen:**
- Automatische Erzeugung von Gebiet und Sammelpunkt beim Start
- Registrierung und Deregistrierung von Charakteren beim Betreten/Verlassen
- Zugriff auf den Sammelpunkt für Bewegungslogik
- Verwaltung der anwesenden Charaktere per Dictionary

## Lizenzierung

- Siehe jeweilige LICENSE-Dateien in den Addons und im Projekt.

## Autoren & Danksagung

- Siehe AUTHORS.md und README.md in den jeweiligen Addons.

## Weiterführende Informationen

- Dokumentation in den Addon-Ordnern (`README.md`)
- Beispielskripte im `Skripte/`-Verzeichnis
- Für Fragen und Beiträge: Bitte Issues oder Pull Requests im Repository nutzen.
