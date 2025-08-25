# Projektkontext: AI Village

Dieses Dokument beschreibt die wichtigsten Konzepte und Klassen des Projekts AI Village auf Basis der Skripte im Verzeichnis `Skripte/Klassen`.

---





## 1. Charaktäre


### 1.1 Spieler

#### 1.1.1 Skriptaufbau

- **Verwendete %Nodes (direkt im Skript referenziert):**
  - `%Skelett` (`Skeleton3D`): Skelettstruktur, perspektivisch für Animationen vorgesehen
  - `%Kopf` (`Marker3D`): Drehpunkt für Blickrichtung und Kamera
  - `%Blick` (`RayCast3D`): Prüft, was der SpielerCharakter ansieht/interagiert
  - `%SpringArm3D` (`SpringArm3D`): Kamerahalterung für Third-Person-Ansicht
  - `%Dialog` (`Gespräch`): UI für Gespräche

- **Export-Variablen:**
  - `individuum` (`Interagierer`): Referenz auf das zugehörige Individuum/Charakterobjekt des SpielerCharakters (z.B. für Inventar, Status, Identität).
  - `maus_gefangen` (`bool`): Steuert, ob die Maus im Fenster gefangen ist (First-/Third-Person-Steuerung, Interaktionsmodus).

- **Aufgabenbereiche:**
  - **Umsehen:**
    - Kopfrotation und Kamerasteuerung über Mausbewegung (`%Kopf`, `%SpringArm3D`).
    - Blickrichtung wird durch `%Blick` (RayCast3D) geprüft, um Objekte/Charaktere im Sichtfeld zu erkennen.
    - `maus_gefangen` steuert, ob die Kamera frei bewegt werden kann oder der Mauszeiger sichtbar ist.
  - **Interagieren:**
    - Ansehen: Prüft per `%Blick`, ob ein Objekt/Charakter betrachtet wird.
    - Ansprechen: Startet bei passender Eingabe ein Gespräch mit einem NichtSpielerCharakter über `%Gespräch`.
    - `maus_gefangen` wird beim Start/Ende von Interaktionen angepasst, um zwischen Steuerung und UI zu wechseln.
    - `individuum` kann für weiterführende Interaktionen (z.B. Inventar, Status) genutzt werden.
  - **Bewegen:**
    - Bewegung und Springen über Tastatureingaben, umgesetzt in `_physics_process()`.
    - Kopf und Körper werden synchronisiert, um natürliche Bewegungen zu ermöglichen.
    - Kollisionserkennung und -vermeidung über Godot-Physik.
  - **Animieren:**
    - `%Skelett` ist als Node vorhanden, Animationen sind noch nicht implementiert, aber vorgesehen für zukünftige Erweiterungen.

#### 1.1.2 Szenenaufbau
- Die Szene `SpielerCharakter.scn` bildet den SpielerCharakter als 3D-Charakter ab:
  - `CharacterBody3D` (Root, mit SpielerCharakter-Skript)
    - `%Skelett` (`Skeleton3D`): Visuelle Darstellung des Körpers
    - `%Kopf` (`Marker3D`): Kopf des SpielerCharakters
      - `%Blick` (`RayCast3D`): Blickrichtung
      - `%SpringArm3D`: 
        - `Camera3D`: Third-Person-Kamera
    - `%Gespräch`: UI für Gespräche
    - `CollisionShape3D`: Kapsel für Kollision
- Die Struktur ermöglicht freie Bewegung, gezielte Interaktion und nahtlose Integration von Gesprächen und Kamera.


### 1.2 NichtSpieler

#### 1.2.1 Skriptaufbau

- **Verwendete %Nodes (direkt im Skript referenziert):**
  - `BTPlayer`: Verhaltensbaum (BehaviorTree, LimboAI), steuert das agentenbasierte Verhalten
  - `%Wegfinder` (`NavigationAgent3D`): Navigation und Bewegungslogik
  - `CollisionShape3D`: Kapsel für Kollision
  - `%Skelett` (`Skeleton3D`): Skelettstruktur, perspektivisch für Animationen vorgesehen
  - `%Kopf` (`Marker3D`): Drehpunkt für Blickrichtung und Wahrnehmung
  - `sync`: Node für Training und Synchronisation von Verhaltensmodellen (noch nicht implementiert)
  - Kinder von `%Kopf`:
    - `%Blick` (`RayCast3D`): Prüft, was der NichtSpielerCharakter ansieht/interagiert
    - `Wahrnehmung` (`Area3D`): Wahrnehmungsbereich für Sichtfeld

- **Export-Variablen:**
  - `marktzeit` (`NodePath` zu ÖkonomischeRealität): Referenz auf die aktuelle Markt-/Zeitinstanz
  - `individuum` (`Reagierer`): Das zugehörige Individuum, enthält u.a. die Ökonomie-Resource (Bedürfnisse, Wohlstand, Status)
  - `beschäftigt` (`bool`, @export_storage): Gibt an, ob der Charakter aktuell beschäftigt ist
  - `zustand` (`NichtSpielerCharakter.VERHALTENSZUSTAND`, @export_storage): Aktueller Verhaltenszustand

- **Aufgabenbereiche:**
  - **Verhalten:**
    - Das Verhalten wird vollständig durch den Verhaltensbaum (`BTPlayer`, LimboAI) bestimmt.
    - Die Node `sync` ist für das Training und die Synchronisation von Verhaltensmodellen vorgesehen (noch nicht implementiert).
  - **Antworten:**
    - Kann auf Gesprächsanfragen reagieren und Dialoge führen (siehe Methoden wie `beginne_gespräch`).
    - Interagiert mit anderen Charakteren und verarbeitet externe Ereignisse.
  - **Animieren:**
    - `%Skelett` ist als Node vorhanden, Animationen sind noch nicht implementiert, aber vorgesehen für zukünftige Erweiterungen.
  - **Bewegen:**
    - Navigation und Bewegung erfolgen über `%Wegfinder` (`NavigationAgent3D`) und Godot-Physik.
    - Kopf und Blick werden dynamisch ausgerichtet, um Ziele und Gesprächspartner zu fokussieren.
  - **Wirtschaften:**
    - Die eigene Ökonomie-Resource (Teil von `individuum`) wird verwaltet, um Wohlstand zu maximieren und "Tod" zu vermeiden.
    - Dazu gehören Statusverwaltung, Bedürfnisbefriedigung und Interaktion mit der Markt-/Zeitinstanz (`marktzeit`).

#### 1.2.2 Szenenaufbau
- Die Szene `NichtSpielerCharakter.tscn` bildet den NichtSpielerCharakter als 3D-Charakter ab:
  - `CharacterBody3D` (Root, mit NichtSpielerCharakter-Skript)
    - `BTPlayer` Verhaltensbaum (Addon LimboAI)
    - `%Skelett` (`Skeleton3D`)
    - `%Wegfinder` (`NavigationAgent3D`)
    - `%Kopf` (`Marker3D`)
      - `%Blick` (`RayCast3D`)
      - `Wahrnehmung` (`Area3D`)
    - `CollisionShape3D`
    - `sync`
- Die Struktur ermöglicht agentenbasiertes Verhalten, Navigation, Wahrnehmung, Interaktion und ist modular für Animation und KI-Training erweiterbar.

#### 1.2.3 Verhaltenssteuerung
- TODO




## 2. Gespräche


### 2.1 Benutzeroberfläche

#### 2.1.1 Skriptaufbau
- Das UI wird aktiviert, sobald ein Gespräch mit einem Charakter beginnt. Das Control `Gespräch` (siehe `Gespräch_skript.gd`) wird sichtbar und mit einer neuen `Unterhaltung`-Resource verknüpft, die den Gesprächsverlauf und die Teilnehmer verwaltet.
- Neue Aussagen werden über die Methoden `empfange_eingabe` und `empfange_antwort` an das UI übergeben. Jede Nachricht erzeugt ein neues `Aussage`-Control in der VBox `Gesprächsinhalt`.
- Die Darstellung jeder Aussage (Name, Text, Icon, Farbe) wird über die Properties des `Aussage`-Controls gesetzt und kann je nach Teilnehmer angepasst werden.
- Der gesamte Gesprächsverlauf wird aus der `Unterhaltung`-Resource rekonstruiert, wenn das UI aktualisiert wird (`_aktualisiere_ui`).
- Das Gespräch kann jederzeit über den Verabschieden-Button beendet werden, was das UI ausblendet und das Signal `gespräch_abgeschlossen` sendet.
- Dynamische Darstellung beliebig vieler Teilnehmer und Aussagen, Gesprächsverlauf bleibt sichtbar und wird automatisch gescrollt.
- Flexible Anpassung der Darstellung (z.B. Farbe, Name, Icon) je nach Teilnehmer.
- Die gesamte Logik ist modular und kann für verschiedene Gesprächssituationen und Teilnehmer erweitert werden.

#### 2.1.2 Szenenaufbau
- Die Szene `gespräch_oberfläche.tscn` bildet die Gesprächsoberfläche ab:
  - `Control`
    - `MarginContainer`
      - `VBoxContainer`
        - `%verabschieden` (`Button`): Button zum Beenden des Gesprächs
        - `ScrollContainer`
          - `%Gesprächsinhalt` (`BoxContainer`): Container für alle Aussagen
        - `HSplitContainer`
          - `%Antwort` (`LineEdit`): Eingabefeld für Antworten
          - `%Sprechen` (`Button`): Button zum Senden
- Die Szene referenziert das Sprachmodell als eigene Subszene (siehe 2.2).

### 2.2 Sprachmodell

#### 2.2.1 Skriptaufbau
- Das Sprachmodell ist als eigene Szene ausgelagert und wird von der Benutzeroberfläche referenziert.
- Die Szene `Sprachmodell.tscn` enthält die KI-Logik für Antworten und Aufgaben.
- Bindet das Sprachmodell für KI-generierte Antworten ein und verwaltet Aufgaben und Gedankengänge.

#### 2.2.2 Szenenaufbau
- Die Szene `Sprachmodell.tscn` besteht aus:
  - `NobodyWhoModel`
    - `Gedanken` (`NobodyWhoChat`): Verwaltung der laufenden Konversationen
    - `Aufgaben` (`NobodyWhoEmbedded`): Verwaltung von Aufgaben und Prompt-Logik

#### 2.2.3 Kontext
- TODO




## 3. Marktwirtschaft


### 3.1 ÖkonomischeRealität
- Erweitert: `Node`
- Zentrale Steuerungseinheit für alle ökonomischen Abläufe und das Zeitmanagement eines Spielstands.
- Initialisiert und verwaltet die Kernressourcen:
  - `Zeit` (Tick- und Zeitmanagement, siehe ResourceVerzeichnis)
  - `Markt` (Transaktionen, Teilnehmer, Zeitstempel)
  - `Ökonomie` (globale ökonomische Parameter und Regeln)
- Modularer Aufbau: Ressourcen können flexibel von anderen Systemen genutzt und erweitert werden.
- Zeitmanagement:
  - Hält eine Referenz auf die Zeit-Resource und synchronisiert regelmäßig die Ticks (`_process(delta)`)
  - Steuert, ob die Zeit fortschreitet (`fließt`), und wie viele Ticks pro Sekunde verarbeitet werden (`tick_je_sek`)
  - Aktualisiert den aktuellen Zeitpunkt und sorgt für die zeitliche Konsistenz aller ökonomischen Prozesse
- Marktintegration:
  - Alle Markttransaktionen werden mit Zeitstempeln versehen
  - Die Markt-Resource verwaltet Teilnehmer, Waren, Transaktionen und deren Historie
- Initialisierung:
  - Beim Start werden Zeit, Markt und Ökonomie automatisch erzeugt, falls sie nicht vorhanden sind
- Methoden und Logik:
  - `_ready()`: Initialisiert und verknüpft Ressourcen
  - `_process(delta)`: Aktualisiert Zeit und synchronisiert ökonomische Abläufe
  - Statische Hilfsmethoden zur Definition von Zeiteinheiten und deren Tick-Werten (`_definition(einheit: ZEITEINHEIT) -> int`)
- Erweiterbarkeit:
  - Weitere Systeme (z.B. Lebensraum, Individuum) können an die ÖkonomischeRealität andocken und deren Ressourcen nutzen
  - Ermöglicht eine nachvollziehbare, zeitbasierte und modulare Simulation ökonomischer Prozesse

---



