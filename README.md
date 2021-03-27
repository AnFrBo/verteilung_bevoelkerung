# Entwicklung der räumlichen Verteilung der Bevölkerung in den deutschen Bundesländern (2000-2016)

Die Wanderungsstatistik zeigt die räumliche Mobilität der Bevölkerung und dient als wichtige Informationsquelle für die amtliche Bevölkerungsfortschreibung. Sie wird von vielen Bundesministerien und -behörden, wie bspw. dem Bundesamt für Migration und Flüchtlinge und dem Bundesamt für Bauwesen und Raumordnung, sowie Wirtschaftsverbänden, internationalen Organisationen sowie diversen Medien, genutzt (siehe Fachserie 1.1.2 (ZDB-ID: 2157328-1) des statistischen Bundesamtes, 2008 Reiter Qualitätsbericht). Auf die Veränderung der Bevölkerungsstruktur, die sich durch Wanderungen ergeben, kann so entsprechend reagiert werden. Das Bundesamt für Migration und Flüchtlinge kann bspw. mit neuen Integrationsgesetzen oder -programmen reagieren. Für Regionen, die stark wachsen, kann das Bundesamt für Bauwesen und Raumordnung ausreichend Wohnraum schaffen. Außerdem kann die Politik bewusste Anreize schaffen, um Fortzugs-Gebiete zu besiedeln.

Um diese Veränderungen der räumlichen Verteilung der Bevölkerung darzustellen, habe ich eine Shiny App gebaut, die die Ab- und Zuwanderungen pro Bundesland im Zeitraum von 2000 bis 2016 darstellt. Sie ist interaktiv und ein Zielland sowie ein Zeitpunkt kann jeweils ausgewählt werden. 

Die Visualisierung kann durch das Ausführung des app.R codes erreicht werden (s. hierzu setup.txt). Außerdem wird die App wird auf einem Shiny.io Server gehostet. Jedoch wird sie nach einer Zeit automatisch interaktiv und muss wieder aktiviert werden. Bei Bedarf schreibt mir gerne eine Mail an anna_bothe@gmx.de.

## Daten

Die zugrundeliegenden Daten 20XY_salden.csv sind von mir aufbereitet worden. Die entsprechenden Rohdaten werden von dem Statistischen Bundesamt in der Fachserie 1 (Bevölkerung und Erwerbstätigkeit), Reihe 1.2 (Wanderungen) veröffentlicht (ZDB-ID: 2157328-1).

Die geographischen Daten sind kostenlos auf [GADM Data](https://gadm.org/download_country_v3.html) verfügbar. Allerdings werden diese alle 3-6 Monate aktualisiert, deshalb habe ich die von mir genutzten Daten dem Ordner App &rarr; Data hinzugefügt. Als Granularitätsgrad habe ich Level 1 gewählt, da diese die Längen- und Breitengrade auf Bundeslandebene enthalten. Um das Datenvolumen zu reduzieren, nutze ich für meine Analyse nur 10% der Daten des multipolygon shapefiles, was ausreichend ist. 

Der Code wurde in R/RStudio geschrieben.

## Organization

__Autor:__ Anna Franziska Bothe <br>
__Institut:__ Humboldt-Universität zu Berlin, bologna.lab <br>
__Kurs__: Datengrundlagen der Wirtschaftspolitik / Wirtschaftsstatistik <br>
__Semester:__ WS 2019/20 <br>


## Content

```
.
├── App                                 # Ordner beinhaltet en Code für die App sowie alle Datensätze
├── Seminararbeit_ABothe_576309.pdf     # finale Seminararbeit
├── README.md                           # diesen readme file
├── requirements.txt                    # enthält alle genötigten libraries
├── setup.txt                           # beschreibt Ausführungspipeline

```






