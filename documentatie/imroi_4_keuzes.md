# IMROI 4.0.0.
## samengevoegd datamodel (verstrekt op 20-10-2020)

## Doel document

**Inleiding**

Er zijn meerdere sessies geweest om keuzes te maken in de verschillen in registraties gebaseerd op het IMROI. Vanuit IMROI zijn er twee datamodel versies, de versies zouden samen moeten komen zodat de diverse regios hetzelfde datamodel kunnen gebruiken. Het grote voordeel is dat de Veiligheidsregio dan kan kiezen welke applicatie in te zetten voor OIV. Dit kan COGO en/of QGIS of iets heel anders zijn. De huidige modellen zijn niet compatibel.

Naast dat er twee modellen zijn, zijn er verschillende versies. Deze versies variëren tussen (2.x.x.), 3.0.4. – 3.2.0. Een van de doelen is dan ook grip te krijgen op het datamodel IMROI. Het eigenaarschap en akkoord op wijzigingen komt vanuit de werkgroep IMROI en niet vanuit de individuen bij één van de Veiligheidsregio's.

## Gevaarlijke stoffen

**Verschillen**

De tabellen zijn in principe hetzelfde. De inhoud van IMROI wordt dus voldaan. Het verschil zit hem echter in het aan elkaar knopen van de tabellen.

Zo zitten de schade cirkels aan de opslag locatie gerelateerd bij de een. Bij de ander zit deze aan de gevaarlijke stof.

Bij de een is er één punt (opslag) met meerdere (administratieve) gevaarlijke stoffen. Bij de ander heeft elke gevaarlijke stof één punt (opslag+administratief).

**Visueel**

![Image of gevaarlijkestof](https://github.com/bburgemeestre/OIV-IMROI/blob/main/documentatie/images/gevaarlijkestof.png)

**Datamodel Veiligheidsregio's QGIS**

Stap 1: er wordt een opslag locatie ingetekend (punt) **objecten.gevaarlijkestof_opslag**.

Stap 2: er wordt een gevaarlijke stof (administratief) **objecten.gevaarlijkestof** aan een **object.gevaarlijkestof_opslag** gehangen.

Stap 3: als er een schade_cirkel is dan kijkt deze naar **objecten.gevaarlijkestof_opslag** en genereerd een schadecirkel in **objecten.gevaarlijkestof_schade_cirkel**

**Datamodel Veiligheidsregio's COGO**

Stap 1: er wordt een opslag locatie ingetekend (punt) **objecten.gevaarlijkestof_opslag**. Hieraan zit **object.gevaarlijkestof** gejoind.

Stap 2: de schade_cirkel kijkt naar **object.gevaarlijkestof** en geeft dus meerdere cirkels als er meerdere stoffen met een straal aanwezig zijn. Dit komt omdat elke gevaarlijke stof een locatie heeft.

### Aanbeveling

Om het simpel te houden voor de gebruiker is het makkelijk om per stof een punt te prikken in de kaart, je kan altijd als er een wijziging komt één van de punten verwijderen of verplaatsen. Dit maakt het net als de overige objecten zoals pictogrammen wat meer eenduidig in de werkwijze. De mogelijkheid is er ook om &quot;nauwkeurig&quot; in een pand de opslag per stof in de ruimte weer te geven als hier behoefte aan is.

Dit is ook in de lijn hoe bijvoorbeeld een basisregistratie zoals adressen en gebouwen de data registreert, een punt per adres.

Als er behoefte is aan één symbool dan kan de afnemende applicatie (QGIS,COGO,WGP, ArcGIS) een cluster point visualisatie doen.

Wil men alleen één schadecirkel zien van het cluster? Dan kan de view aangepast worden door de grootste straal te pakken als visualisatie. Bijvoorbeeld:
```
With gevaarlijke_stof as (

SELECT gvs.id,

gvs.opslag_id,

gvs.omschrijving,

vnnr.vn_nr,

vnnr.gevi_nr,

vnnr.eric_kaart,

gvs.hoeveelheid,

gvs.eenheid,

gvs.toestand,

o.object_id,

o.formelenaam,

ops.bouwlaag,

ops.bouwdeel,

st_buffer(ops.geom, gsc.straal::double precision)::geometry(Polygon,28992) AS geom,

st_area(st_buffer(ops.geom, gsc.straal::double precision)::geometry(Polygon,28992)) AS area,

ops.locatie,

round(st_x(ops.geom)) AS x,

round(st_y(ops.geom)) AS y

FROM objecten.gevaarlijkestof gvs

JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON gvs.id = gsc.gevaarlijkestof_id

LEFT JOIN objecten.gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id)

Select max(area), geom from gevaarlijke_stof group by object_id;
```
**Aanpassing werkwijze**

Per gevaarlijke stof accepteren dat er een locatie aan hangt, er kan dan in de visualisatie een groep gemaakt worden op basis van de locatie. Zowel QGIS als COGO en andere applicaties kan een symbool clusteren.

Voor de gebruiker is het simpel en efficiënt want je kiest een symbool en klikt op de kaart. Je hebt dan meteen de juiste gegevens en gaat door met de volgende gevaarlijke stof (punt) als je er aan toe bent.

## Repressief object (verschil in terreinen)

**Verschillen**

**Noot vooraf**

- Een object (ingang, sleutelbuis, afsluiter) hoort altijd bij een repressief object.
- Een object (ingang, sleutelbuis, afsluiter) hoort altijd bij een bouwlaag (als die er is) en krijgt dit kenmerk mee
- Een bouwlaag wat op een terrein ligt krijgt het kenmerk van het repressieve object mee, het repressieve object is in dit geval het terrein.

**Veiligheidsregio's QGIS**

Het repressieve object is bij QGIS altijd een terrein. Als een pand wordt ingetekend dan wordt er altijd om het pand een terrein getekend als eerste stap.

**Veiligheidsregio's COGO**

Bij COGO wordt het pand (lees bouwlaag) als repressief object gebruikt en soms een terrein ingetekend.

Nu blijkt niet elke regio de voorkeur te hebben om altijd een terrein te moeten tekenen ondanks dat het IMROI model daar wel van uit ging in de bouw er van, IMROI is echter nog niet vast gesteld en uit voortschrijdend inzicht blijkt dat de configuratie pand = altijd terrein niet altijd wenselijk.

| **Scenario** | Pand (lees bouwlaag) | Terrein | Repressief objectObjecten.object | Geometrie pand in objecten.bouwlagen | Geometrie terrein in objecten.terreinen |
| --- | --- | --- | --- | --- | --- |
| ![Image of scenario_1](https://github.com/bburgemeestre/OIV-IMROI/blob/main/documentatie/images/scenario_1.png) | Ja | Ja, genereer (trigger) | Geovlak terrein | X, y | X, y |
| ![Image of scenario_1](https://github.com/bburgemeestre/OIV-IMROI/blob/main/documentatie/images/scenario_2.png) | Ja | Nee | Geovlak pand | X, y | |
| ![Image of scenario_1](https://github.com/bburgemeestre/OIV-IMROI/blob/main/documentatie/images/scenario_3.png) | Nee | Ja, teken | Geovlak terrein | | X, y |
| ![Image of scenario_1](https://github.com/bburgemeestre/OIV-IMROI/blob/main/documentatie/images/scenario_4.png) | Ja, meerdere | Ja, teken | Geovlak terrein | X, y , x, y …. | X, y |

### Aanbeveling

**Om samen te komen kan het volgende ingericht worden:**

Het terrein vlak opslaan in het repressieve object, in de tabel **objecten.object**. Als er geen terrein vlak is wordt het pand vlak gebruikt als geovlak / repressief object.

Het repressieve object is een punt. Zodra dit punt is geplaatst kan er een terrein OF pand ingevoerd worden als startpunt. Kies je voor een terrein? Teken dan een vlak in, het terrein wordt opgeslagen in **objecten.object/objecten.terrein.** Het repressieve object krijgt naast het punt ook het geovlak opgeslagen in de tabel **objecten.object.**

Wordt er niet gekozen voor het intekenen van een terrein? Dan wordt het pand gebruikt als geovlak. Teken vanuit het represseive object ( **objecten.object** ) een punt en het dichtstbijzijnde pand wordt gepakt als geovlak/terrein.

Wil je naast het pand ook een terrein hebben maar niet intekenen? Maak hier dan een automatische berekening van. De regio kan dan kiezen het pand (bouwlaag) als geovlak te gebruiken of het PAND+100 meter met een trigger vullen richting **objecten.terrein**.

In de tabel objecten.bouwlagen worden de pand/bouwlaag contouren altijd opgeslagen.

1. **Pand (zonder terrein):** het pand is het repressieve object en wordt opgeslagen in een **objecten.bouwlagen** EN **objecten.object**
2. **Terrein (zonder pand):** het terrein wordt opgeslagen in **objecten.object** EN **objecten**. **terrein**.
3. **Terrein met pand(en):** het terrein wordt opgeslagen in **objecten.object** EN **objecten**. **terrein**. Het pand wordt opgeslagen in **objecten.bouwlagen**.

**Aanpassingen terreinen beknopt**

1. trigger toevoegen aan tabel objecten.terreinen -- objecten.object (geovlak)
2. Views voor voertuigen kunnen aangepast worden. Bv: objecten.view_bouwlagen
  1. Select distinct + union op object verdwijnt
  2. Left join met objecten terrein en historie verdwijnt
  3. Ruimtelijke selectie verdwijnt
  4. Historietabel (uitleg komt) verdwijnt
  5. De relatie is er wel maar versimpelt.
3. Aanpassing in objecten.object, hierin komt:
  1. Geovlak

### Aanpassing terrein uitgewerkt

**Tabel aanpassing objecten.terrein**

Tabel objecten.terrein krijgt een extra RULE richting **objecten.object** dit omdat de view(s) (voor voertuigen) dan gebruik kan maken van deze geometrie en geen left join + group by nodig heeft.

**RULE toevoegen:**
```
CREATE OR REPLACE RULE object_terrein_upd AS

ON UPDATE TO objecten.terrein

DO INSTEAD

(UPDATE objecten.object SET geovlak = new.geovlak

WHERE (object.id = new.id));

**View aanpassing**

**grijs komt later te sprake in historie**

**Geel verdwijnt**

CREATE OR REPLACE VIEW objecten.view_bouwlagen

AS

SELECT bl.id,

bl.geom,

bl.datum_aangemaakt,

bl.datum_gewijzigd,

bl.bouwlaag,

bl.bouwdeel,

part.object_id,

part.formelenaam

FROM objecten.bouwlagen bl

JOIN ( SELECT DISTINCT o.formelenaam,

o.id AS object_id,

st_union(t.geom)::geometry(MultiPolygon,28992) AS geovlak

FROM objecten.object o

LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id

FROM objecten.historie historie_1

WHERE historie_1.object_id = o.id

ORDER BY historie_1.datum_aangemaakt DESC

LIMIT 1))

LEFT JOIN objecten.terrein t ON o.id = t.object_id

WHERE historie.status::text = in gebruik::text AND (o.datum_geldig_vanaf \&lt;= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot  now() OR o.datum_geldig_tot IS NULL)

GROUP BY o.formelenaam, o.id) part ON st_intersects(bl.geom, part.geovlak);

ALTER TABLE objecten.view_bouwlagen

OWNER TO oiv_admin;
```
**Nieuwe situatie view:**
```
SELECT bl.id,

bl.geom,

bl.datum_aangemaakt,

bl.datum_gewijzigd,

bl.bouwlaag,

bl.bouwdeel,

o.id object_id,

o.formelenaam,

o.status

FROM objecten.bouwlagen bl

JOIN objecten.object o on bl.id = o.id

WHERE o.status::text = in gebruik::text AND

o.datum_geldig_vanaf \&lt;= now() OR o.datum_geldig_vanaf IS NULL

AND o.datum_geldig_tot  now() OR o.datum_geldig_tot IS NULL;
```
## Historietabel

**Verschillen**

**Veiligheidsregio's QGIS**

Maakt gebruik van objecten.historie en matrixcode. Naast QGIS maakt ook voertuig (views) gebruik van het status veld in objecten.historie. Is een repressief object in concept dan wordt die niet weergegeven bijvoorbeeld.

**Veiligheidsregio's COGO**

COGO anders opgelost: regio tabel toegevoegd. Historietabel wordt niet gebruikt. COGO gebruikt objecten_plus voor status.

### Aanbeveling

Historietabel impact is groot vanuit QGIS altijd eerst concept en dan richting in gebruik. Omdat we een nieuwe start willen maken is het toch aan te bevelen deze aan te passen.

Het doel is dit simpel en efficiënt in te richten wat de performance ten goede komt. Ook is de naamgeving &quot;historie&quot; verwarrend als er wel daadwerkelijk historie opbouw plaats gaat vinden.

Linksom of rechtsom, de huidige datamodellen willen een status toekennen. De historietabel maakt het echter complex. Door deze er uit te halen en te vervangen met extra velden in het repressieve object ben je er.

**Aanpassingen**

**Repressief object (objecten.object tabel)**

De tabel object krijg de volgende extra velden:

Uit historietabel:

Teamlid_behandeld_id

Teamlid_afgehandeld_id

Status -- status_type (concept, in gebruik, archief)

Aanpassing -- aanpassing_type (aanpassing, nieuw, update)

Matrix_code -- matrix_code ():

998 &quot;998&quot; &quot;Waterongevallen&quot; &quot;X&quot; 998

999 &quot;999&quot; &quot;Geen matrix code&quot; &quot;X&quot; 999

Als laatste extra veld:

Plus_info (json)

De reden van dit veld is dat je extra informatie kwijt kan, eigenlijk zou dit ook gebruikt kunnen worden voor matrix_code, teamlid etc. 

Dit veld kan gebruikt worden voor bijvoorbeeld: privacy achtige zaken als: een toegangscode tot een repressief object, i.p.v. enkel de formelenaam een contactgegeven of welke informatie dan ook.

Dat ziet er dan bijvoorbeeld zo uit:
```
({ &quot;contactpersoon&quot;: &quot;John Doe&quot;, &quot;speciale toegang&quot;: {&quot;object&quot;: &quot;sleutelbuis&quot;,&quot;locatie&quot;: aan de linker kant van de voordeur}});
```
Wat levert deze aanpassing op? Minder complex model, om weer terug te komen op de view voor voertuigen:

**Huidige view:**
```
CREATE OR REPLACE VIEW objecten.view_bouwlagen

AS

SELECT bl.id,

bl.geom,

bl.datum_aangemaakt,

bl.datum_gewijzigd,

bl.bouwlaag,

bl.bouwdeel,

part.object_id,

part.formelenaam

FROM objecten.bouwlagen bl

JOIN ( SELECT DISTINCT o.formelenaam,

o.id AS object_id,

st_union(t.geom)::geometry(MultiPolygon,28992) AS geovlak

FROM objecten.object o

LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id

FROM objecten.historie historie_1

WHERE historie_1.object_id = o.id

ORDER BY historie_1.datum_aangemaakt DESC

LIMIT 1))

LEFT JOIN objecten.terrein t ON o.id = t.object_id

WHERE historie.status::text = in gebruik::text AND (o.datum_geldig_vanaf \&lt;= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot  now() OR o.datum_geldig_tot IS NULL)

GROUP BY o.formelenaam, o.id) part ON st_intersects(bl.geom, part.geovlak);

ALTER TABLE objecten.view_bouwlagen

OWNER TO oiv_admin;
```
**Nieuwe view:**
```
CREATE OR REPLACE VIEW objecten.view_bouwlagen

AS

SELECT bl.id,

bl.geom,

bl.datum_aangemaakt,

bl.datum_gewijzigd,

bl.bouwlaag,

bl.bouwdeel,

o.object_id,

o.formelenaam,

o.status

FROM objecten.bouwlagen bl

JOIN objecten.object o on bl.object_id = o.id

WHERE object.status::text = in gebruik::text AND o.datum_geldig_vanaf \&lt;= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot  now() OR o.datum_geldig_tot IS NULL;
```
Een repressief object heeft maar 1 actuele status, zolang datum_geldig_tot leeg is, is dit het juiste repressieve object.

Een terrein hoeft niet meer gerelateerd te worden aan het repressieve object of de historietabel omdat die al reeds (als die bestaat!) opgeslagen zit in objecten.object. Als een terrein niet bestaat dan is het pand het repressieve object in objecten.object.

Een ruimtelijke selectie tussen bouwlaag en terrein+object is niet meer nodig omdat de relatie tussen object en terrein plat geslagen is en het object gekoppeld kan worden met de bouwlaag op basis van object_id. objecten.bouwlagen object_id = objecten.object id.

## Uitvoering samenvoegen datamodellen tot LTR

### Voorstel aan OIV IMROI werkgroep

Ons voorstel is naast de aanpassingen die komen ook vanuit de OIV IMROI groep een hard besluit te nemen om een Long Term Release uit te rollen.

Naast de aanpassing van het datamodel is het echt zaak dat er geen wijzigingen komen in het model voor de LTR versie. Dit kan echt niet bijgehouden worden zoals het nu gaat. Het is niet duidelijk wie op welke versie zit. Op d.d. 15-10-2020 lijkt dit de situatie: VRAA+VRBM = 3.0.4. ZAWA/Friesland 3.1.7, VRBZO 3.0.8. VRNHN 2.x.x.

Het is erg veel uitzoekwerk wat de wijzigingen zijn en het is niet duidelijk welke versie werkt met de QGIS plug-in. Support/samenwerken landelijk is op deze manier vrijwel onmogelijk. Het beoordelen van versie 3.0.4. is bijvoorbeeld ook niet mogelijk omdat die niet op Github staat en enkel gemaild is.

**Een paar uitgangspunten:**

1. **Het samengevoegde datamodel omarmen** , dit kost zowel COGO als de QGIS plug-in werk.
  1. De aanpassingen levert de werkgroep aan, men krijgt een kant en klaar leeg datamodel met een overzicht waarin de wijzingen zitten.
  2. Dit datamodel is een combinatie van: 3.0.4. en 3.2.0. (dit is eigenlijk niet het uitgangspunt, dit zou 3.0.4. zijn maar enige coulance is geboden richting 3.2.0.). Met cruciale keuzes voor terreinen, gevaarlijke stoffen en historie.
2. **Het samengevoegde datamodel komt op Github** en wordt beheert door de werkgroep en niet door de externe ontwikkelaars. De werkgroep zet Github op.
3. **Het samengevoegde datamodel is versie 4.0.0**. Dit model krijgt een inzageperiode van een paar weken, zowel COGO als QGIS plug-in bouwers krijgen hierin inzage
  1. Dit voorkomt dat er meerdere versies in het land actief zijn, als er een versie is voor bv. Friesland waarin her en der aanpassingen zijn in 3.0.4 – 3.2.0. dan is dat aan de ontwikkelaars om dat op te lossen. Het is geen doen om mutaties die dagelijks in het datamodel gemaakt worden bij te houden. Dit zal vanaf nu periodiek gaan vanuit de werkgroep.
  2. We zijn als Veiligheidsregio eigenaar van het model, we accepteren dus alleen aanpassingen waarop akkoord wordt geven. Het akkoord vind plaats in overleg en wordt in Github doorgevoerd.
4. **Duidelijke afspraken wat het datamodel is** :
  1. Views voor voertuigen, COGO, QGIS duidelijk scheiden van het datamodel. Niet elke regio heeft bijvoorbeeld (dezelfde) voertuig views nodig.
  2. Functionaliteit specifiek voor COGO, QGIS duidelijk scheiden van het datamodel (denk hierbij aan bijvoorbeeld het automatisch berekenen van het dichtstbijzijnde pand/bouwlaag bij een repressief object of het vullen van een gebruikersnaam). Hoe een applicatie het datamodel vult moet los staan van het datamodel (schema).
  3. Doorontwikkeling voor (regio) specifieke vragen zo veel mogelijk scheiden. Extra velden toevoegen aan het datamodel en doorvoeren naar IMROI kan, maar dit zal beoordeeld worden door de werkgroep of dit ook landelijk doorgevoerd wordt.
  4. Wijzigingen worden pas doorgevoerd nadat de gebruikersgroep OIV IMROI de wijzigingen heeft beoordeeld en goedgekeurd.

**Beknopt wordt het volgende geleverd vanuit de werkgroep IMROI:**

1. Leveren samengevoegd datamodel, hierin zit:
  1. Aanpassing repressief object voor terreinen / bouwlagen(panden)
  2. Eenduidige werkwijze en opslag voor gevaarlijke stoffen
  3. Een aanpassing aan opslag status (historietabel)
  4. TYPES worden vervangen met ```\*_type``` tabellen
  5. SERIALS worden met IDENTITY columns vervangen
  6. Performance gaat enorm omhoog voor views en specifiek voor voertuig views.
2. Het opzetten van een Github:
  1. Is onder beheer van de gebruikersgroep OIV IMROI
  2. Ontwikkelaars kunnen de versie niet afdwingen / doorvoeren zonder akkoord werkgroep.

