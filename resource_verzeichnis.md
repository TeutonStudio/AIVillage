# ResourceVerzeichnis

## Zeit
- **Zeit**: Resource zur Verwaltung des Spielfortschritts in Ticks und zur Synchronisation mit einem aktuellen Zeitpunkt.
  - Eigenschaften:
    - `fließt`: Gibt an, ob die Zeit fortschreitet
    - `ticks`: Aktuelle Tickzahl
    - `zeit`: Referenz auf eine Zeitpunkt-Resource
    - **Zeiteinheiten und Definitionen:**
      - `ZEITEINHEIT` (enum):
        - `Tage`: Ein Tag besteht aus 3600 Ticks (Standardwert, siehe _definition())
        - `Wochen`: Eine Woche = Anzahl Tage * 7 (Wochentage)
        - `Jahre`: Ein Jahr = Anzahl Wochen * wochen_je_jahr (aus Zeitpunkt)
      - `WOCHENTAG` (enum):
        - `Montag`, `Dienstag`, `Mittwoch`, `Donnerstag`, `Freitag`, `Samstag`, `Sonntag`
      - **Dynamische Definition:**
        - Die Tick-Anzahl pro Einheit wird über die statische Methode `_definition(einheit: ZEITEINHEIT) -> int` berechnet:
          - `Tage`: 3600 Ticks
          - `Wochen`: 3600 Ticks * 7 (Anzahl Wochentage)
          - `Jahre`: Wochen-Ticks * wochen_je_jahr (aus Zeitpunkt)
      - **Bedeutung:**
        - Die Zeiteinheiten sind flexibel und können über die Enums und die _definition()-Methode angepasst werden.
        - Die tatsächliche Tick-Anzahl pro Einheit ergibt sich dynamisch aus den aktuellen Einstellungen und Konstanten im Code.
  - Methoden:
    - `aktualisere_ticks(delta)`: Erhöht die Ticks je nach Zeitfortschritt
  - Fähigkeiten:
    - Synchronisiert Tick-basierte Zeit mit einem Zeitpunkt
    - Grundlage für tageszeit- und zeitpunktabhängige Logik

- **Zeitpunkt**: Resource, die einen bestimmten Zeitpunkt im Spiel (Minute, Stunde, Tag, Woche, Jahr) abbildet und Zeitoperationen ermöglicht.
  - Eigenschaften:
    - `minute`, `stunde`, `tage`, `woche`, `jahre`: Zeitkomponenten
  - Methoden:
    - `setze_auf_tick(ticks)`: Setzt den Zeitpunkt anhand der aktuellen Ticks
    - `erhalte_uhrzeit(ticks)`: Gibt die Uhrzeit als String zurück
    - `verschiebe(um, minus)`: Verschiebt den Zeitpunkt vor/zurück
    - `erhalte_datum()`: Gibt das aktuelle Datum als String zurück
  - Fähigkeiten:
    - Umrechnung zwischen Ticks und Zeitkomponenten
    - Vergleich, Addition und Subtraktion von Zeitpunkten

- **Zeitraum**: Resource, die einen Zeitraum mit Start- und Endzeitpunkt abbildet und Zeitvergleiche ermöglicht.
  - Eigenschaften:
    - `start`, `ende`: Zeitpunkt-Resourcen
  - Methoden:
    - `innerhalb(zp)`: Prüft, ob ein Zeitpunkt im Zeitraum liegt
    - `verändere_nach_hinten(länge)`, `verändere_nach_vorne(länge)`: Verschiebt Start/Ende
    - `länge()`: Gibt die Dauer als Zeitpunkt zurück
  - Fähigkeiten:
    - Verwaltung und Vergleich von Zeitintervallen
    - Unterstützung für Verträge, Ereignisse und Zeitfilter


## Markt
- **Markt**: Zentrale Resource zur Verwaltung aller Marktteilnehmer, Waren, Transaktionen und Preisbildung.
  - Eigenschaften:
    - `teilnehmer`: Liste oder Dictionary aller registrierten Marktteilnehmer (z.B. Individuen, Geschäfte)
    - `transaktionen`: Historie aller abgeschlossenen Transaktionen, jeweils mit Zeitstempel
    - `waren`: Verzeichnis aller gehandelten Warenarten
    - `preise`: Aktuelle Preisliste für alle Waren
  - Methoden:
    - `registriere_teilnehmer(teilnehmer)`: Fügt einen neuen Teilnehmer hinzu
    - `führe_transaktion_aus(transaktion)`: Führt eine Transaktion durch und aktualisiert Historie und Inventare
    - `ermittle_preis(ware)`: Gibt den aktuellen Marktpreis einer Ware zurück
  - Fähigkeiten:
    - Verwaltung und Abwicklung von Kauf- und Verkaufsvorgängen
    - Preisbildung und Marktregulierung
    - Historisierung und Auswertung des Marktgeschehens

- **Ware**: Resource, die eine handelbare Einheit beschreibt (z.B. Rohstoff, Produkt, Konsumgut).
  - Eigenschaften:
    - `name`: Name der Ware
    - `typ`: Kategorie/Subtyp (z.B. Verzehrbar, Anziehbar, Verarbeitbar)
    - `eigenschaften`: Dictionary mit spezifischen Attributen (z.B. Nährwert, Haltbarkeit, Qualität)
  - Subkategorien:
    - **Verzehrbar**: Ware, die konsumiert werden kann (z.B. Nahrung, Getränke) und Statuswerte beeinflusst
    - **Anziehbar**: Ware, die getragen werden kann (z.B. Kleidung, Ausrüstung) und Eigenschaften/Status verändert
    - **Verarbeitbar**: Ware, die als Rohstoff oder Zwischenprodukt für weitere Waren dient (z.B. Holz, Erz, Stoffe)
  - Fähigkeiten:
    - Kapselung aller für Handel, Verbrauch oder Weiterverarbeitung relevanten Eigenschaften
    - Unterstützung für Spezialisierung durch Subklassen oder Typen

- **Warenkorb**: Resource zur Verwaltung einer Sammlung von Waren für Transaktionen, Inventare oder Angebote.
  - Eigenschaften:
    - `waren`: Dictionary oder Array aller enthaltenen Waren und deren Mengen
    - `besitzer`: Referenz auf den Besitzer (z.B. Individuum, Geschäft)
  - Methoden:
    - `add(ware, menge)`: Fügt eine Ware in gegebener Menge hinzu
    - `remove(ware, menge)`: Entfernt eine bestimmte Menge einer Ware
    - `get_menge(ware)`: Gibt die aktuelle Menge einer Ware zurück
  - Fähigkeiten:
    - Verwaltung von Inventaren, Angeboten und Nachfragen
    - Unterstützung für Transaktionen, Lagerhaltung und Verbrauch

## Charaktäre
- **Individuum**: 
  - Die grundlegende Resource für alle lebendigen Entitäten im Spiel (NPCs, SpielerCharakter).
  - Eigenschaften:
    - `geschlecht`, `spitzname`, `gesprächs_farbe`: Basisattribute
    - `stammbaum`: Verwandtschaftsstruktur
    - `ökonomie`: Referenz auf die individuelle Ökonomie-Resource (Bedürfnisse, Status, Antriebe)
  - Fähigkeiten:
    - Kapselt alle für KI, Dialog, Ökonomie und Identität relevanten Daten
    - Bindeglied zwischen Verhaltensbaum, Sprachmodell, Persönlichkeit und Ökonomie
    - Grundlage für alle lebendigen Spielobjekte

- **Reagierer** (Individuum): 
  - Spezialisierte Resource für KI-gesteuerte, ökonomische Charaktere (z.B. NPCs).
  - Eigenschaften:
    - `persönlichkeit`: Individuelle Erinnerungen, Beziehungen, Prompt-Logik
    - `sprachmodell`: Auswahl und Verwaltung des Sprachmodells für KI-Dialoge
  - Methoden:
    - `erhalte_system_prompt()`: Generiert einen System Prompt für das Sprachmodell
    - `erhalte_modellpfad()`: Liefert den Pfad zum gewählten Sprachmodell
  - Fähigkeiten:
    - Ermöglicht autonome, KI-gesteuerte Agenten mit eigenem Status, Erinnerungen und Entscheidungsgrundlagen
    - Integration in ökonomische und soziale Systeme des Spiels

- **Interagierer** (Individuum): 
  - Spezialisierte Resource für den SpielerCharakter.
  - Eigenschaften:
    - Erbt alle Eigenschaften von Individuum
  - Fähigkeiten:
    - Dient als Schnittstelle für die Interaktion des SpielerCharakters mit der Spielwelt
    - Kann eigene Logik für Eingaben und Interaktionen enthalten

## Marktteilnahme
- **Ökonomie**: Resource, die individuelle ökonomische Eigenschaften, Bedürfnisse und Antriebe eines Charakters kapselt.
  - Eigenschaften:
    - `ziel`: Aktuelles Ziel/Position im Raum
    - `inventar`: Warenkorb mit aktuellen Besitztümern
    - `währung`: Geldbetrag
    - `arbeitsverträge`: Liste von Arbeitsverträgen
    - Private Eigenschaften: `durst`, `hunger`, `dopamin` (Motivation/Glück)
    - Öffentliche Eigenschaften: `energie`, `hygiene`
  - Methoden:
    - `ist_lebendig()`: Gibt an, ob der Charakter noch handlungsfähig ist (abhängig von Grundbedürfnissen)
  - Fähigkeiten:
    - Verwaltung und Bewertung von Bedürfnissen und Statuswerten
    - Steuerung individueller Antriebe und ökonomischer Entscheidungen
    - Grundlage für das Verhalten im Verhaltensbaum eines ÖkonomischenCharakters

- **Arbeitsvertrag**: Resource zur Abbildung eines Arbeitsverhältnisses zwischen zwei Individuen.
  - Eigenschaften:
    - `arbeitgeber`: Name des Arbeitgebers (StringName)
    - `arbeitnehmer`: Name des Arbeitnehmers (StringName)
    - `arbeitszeiten`: Array von Zeitraum-Objekten (Arbeitszeitintervalle)
    - `wochenlohn`: Lohn pro Woche (int)
  - Fähigkeiten:
    - Verwaltung und Auswertung von Arbeitszeiten
    - Verknüpfung mit Individuen und deren Ökonomie
    - Grundlage für Lohnzahlungen, Arbeitszeitkontrolle und Vertragslogik

- **Handelsvertrag**: Resource zur Abbildung eines Handelsgeschäfts zwischen Akteuren.
  - Eigenschaften:
    - `einkaeufer`: Teilnehmer, der Waren kauft
    - `verkaeufer`: Teilnehmer, der Waren verkauft
    - `warenkorb`: Warenkorb mit gehandelten Waren
    - `preisliste`: Preise für die gehandelten Waren
    - `zeitpunkt`: Zeitpunkt der Transaktion
  - Fähigkeiten:
    - Abwicklung und Dokumentation einzelner Handelsvorgänge
    - Verknüpfung mit Markt, Teilnehmern und Waren


## Gespräche
- **Persönlichkeit**: Resource, die individuelle Eigenschaften, Erinnerungen und Beziehungen eines Charakters kapselt.
  - Eigenschaften:
    - `freundschaften`: Liste von Namen befreundeter Individuen
    - `tagesgeschichte`, `wochengeschichte`, `lebensgeschichte`: Arrays mit Erinnerungen und Erlebnissen
  - Methoden:
    - `erhalte_system_prompt()`: Generiert einen System Prompt für das Sprachmodell basierend auf Name, Freunden und Lebensgeschichte
    - `erweitere_geschichte()`: Fügt Abschnitte zu einer Geschichte hinzu
    - `erhalte_gesprächs_abschluß_prompt(gespräch)`: Liefert einen Prompt zur Zusammenfassung eines Gesprächs
  - Fähigkeiten:
    - Speicherung und Erweiterung von Erinnerungen
    - Generierung individueller Prompts für KI-Dialoge
    - Integration von Beziehungen und Lebensgeschichte in die Kommunikation

- **Unterhaltung**: Resource zur Verwaltung und Speicherung von Gesprächsverläufen, Teilnehmern, System Prompts und Dialogparametern. Bindeglied zwischen Dialogsystem und den individuellen Eigenschaften der Teilnehmer.
  - Referenzen: Hält Teilnehmer (z.B. SpielerCharakter, NichtSpielerCharaktere), deren Sprachmodell-Instanzen, System Prompt, Verlauf und aktuelle Eingaben.
  - Methoden:
    - `füge_teilnehmer_hinzu(teilnehmer)`: Fügt einen neuen Teilnehmer hinzu.
    - `entferne_teilnehmer(teilnehmer)`: Entfernt einen Teilnehmer.
    - `empfange_eingabe(teilnehmer, text)`: Verarbeitet eine neue Eingabe und erstellt daraus einen Prompt für das Sprachmodell.
    - `empfange_antwort(teilnehmer, text)`: Nimmt die Antwort des Sprachmodells entgegen und aktualisiert den Verlauf.
    - `aktualisiere_system_prompt()`: Passt den System Prompt dynamisch an die Teilnehmer und den Kontext an.
    - `starte_gespräch()`, `beende_gespräch()`
  - Fähigkeiten:
    - Verwaltung beliebig vieler Teilnehmer
    - Koordination von Sprecherwechseln
    - Generierung und Verwaltung von Prompts für das Sprachmodell
    - Empfang und Integration asynchroner Antworten
    - Synchronisation mit der UI (Gespräch)

- **Aussage**: Resource zur Kapselung eines Gesprächsbeitrags (Dialogpart) im Dialogsystem.
  - Eigenschaften:
    - `pic`: Bildtyp/Index für die Darstellung (z.B. Symbol für Sprecher)
    - `inhalt`: Text der Aussage
    - `propagant`: Name des Sprechers
    - `farbe`: Farbcode für die UI-Darstellung
    - Signal: `neuer_inhalt(inhalt: String)`: Wird ausgelöst, wenn sich der Text der Aussage ändert
  - Fähigkeiten:
    - Kapselt alle für die UI und Logik relevanten Daten einer einzelnen Gesprächszeile
    - Ermöglicht dynamische Aktualisierung und Darstellung im Gesprächsverlauf
    - Bindeglied zwischen Gesprächslogik, Teilnehmern und UI-Komponenten

## Lebesnräume
- **Umgebung**: Resource zur Beschreibung und Verwaltung der aktuellen Umgebung eines Individuums oder einer Gruppe.
  - Eigenschaften:
    - `orte`: Liste oder Dictionary aller relevanten Orte (z.B. Gebäude, Räume, Plätze)
    - `objekte`: Liste aller interaktiven Objekte in der Umgebung
    - `zustände`: Statusinformationen zur Umgebung (z.B. Wetter, Tageszeit, Gefahren)
  - Methoden:
    - `finde_ort(name)`: Sucht und gibt einen bestimmten Ort zurück
    - `aktualisiere_zustand(zustand, wert)`: Setzt oder ändert einen Umweltzustand
  - Fähigkeiten:
    - Kontext für Entscheidungen und Aktionen der Agenten bereitstellen
    - Dynamische Anpassung und Auswertung der Umgebung

- **Möglichkeiten**: Resource zur Verwaltung und Bewertung aller aktuell verfügbaren Aktionen und Interaktionen für ein Individuum.
  - Eigenschaften:
    - `aktionen`: Liste aller möglichen Aktionen (z.B. sprechen, kaufen, arbeiten, konsumieren)
    - `bedingungen`: Bedingungen, die für die Ausführung einer Aktion erfüllt sein müssen
    - `prioritäten`: Bewertung oder Gewichtung der Aktionen nach Relevanz
  - Methoden:
    - `ermittle_möglichkeiten(kontext)`: Gibt alle aktuell verfügbaren Aktionen im gegebenen Kontext zurück
    - `bewerte_aktion(aktion)`: Bewertet eine Aktion nach Nutzen, Kosten oder Erfolgschance
  - Fähigkeiten:
    - Dynamische Generierung und Bewertung von Handlungsoptionen
    - Unterstützung für Entscheidungsfindung im Verhalten von Agenten