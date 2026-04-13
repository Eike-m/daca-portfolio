Andmekvaliteedi Koondraport — Nädal 2
Meeskond: Tooteanalüüsi osakond Tegelane: Toomas Kask Kuupäev: 09.04.2026

Märkus: puhastamine viidi läbi test koopias (sales_test, customers_test). Originaaltabelid on muutmata — tulemused on soovitus production puhastamiseks.

Peamised leiud
Müük — Eike (Roll A)
Kategooria	Leitud probleeme	Pärast puhastamist	Kirjeldus
Duplikaadid	5116 (33,58%)	0	Korduvad sale_id väärtused
NULL customer_id	1487	988	Puuduv kliendi viide
NULL sale_date	0	0	Kontrollitud — puudujääke ei esinenud
NULL total_price	0	0	Kontrollitud — kõikidel tehingutel oli summa
Tuleviku kuupäevad	9	0	Kuupäev > tänane, parandatud 08.04.2026 seisuga
KOKKU	6612	988	
Enne/pärast: 15 234 → 10 118 rida (eemaldatud 5 116 duplikaati)

Kliendid — Krista (Roll B)
Kategooria	Leitud probleeme	Pärast puhastamist	Kirjeldus
Duplikaatsed e-mailid	129	59	Sama e-mail mitmel kliendil
Duplikaatsed telefonid	147	70	Sama telefon mitmel kliendil
NULL eesnimi	0	0	Kontrollitud — puudujääke ei esinenud
NULL perenimi	0	0	Kontrollitud — puudujääke ei esinenud
Ebajärjekindlad linnanimed	43	12	Nt tallinn vs Tallinn
NULL telefon/e-mail	0/380	0/380	E-mail puudub 380 kliendil
KOKKU	699	509	
Enne/pärast: 3 150 → 3 070 rida

Tooted — Egle (Roll C)
Kategooria	Leitud probleeme	Pärast puhastamist	Kirjeldus
Duplikaatsed nimed	12	12	Sama tootenimi mitu korda
NULL nimi/hind	0	0	Kontrollitud — kriitilised väljad korras
Loogilised vead	0	0	Kontrollitud — negatiivseid hindu ei esine
Ebajärjekindlad kategooriad	0	0	Kontrollitud — puudujääke ei esinenud
NULL bränd/kategooria	0	0	Kontrollitud — puuduv klassifitseerimine puudub
KOKKU	12	12	
Ristvalideerimine — Kevin (Roll D)
Kategooria	Leitud probleeme	Kirjeldus
Orbid kliendid	0	Kontrollitud — müük viitab olemasolevale kliendile
Orbid tooted	0	Kontrollitud — müük viitab olemasolevale tootele
Hinna ebakõlad	664	Müügihind ei klapi tootehinnaga (kriitiline!)
Vaimkliendid	592	Klient ei ole kunagi ostnud
Vaimtooted	12	Toodet pole kunagi müüdud
KOKKU	1268	
Koondtabel
Domeen	Leitud	Pärast	% kõigist
Müük (Eike)	6612	988	77,0%
Kliendid (Krista)	699	509	8,1%
Tooted (Egle)	12	12	0,1%
Ristvalideerimine (Kevin)	1268	—	14,8%
KOKKU	8591		100%
Suurim üllatus
Müügiandmetest 33,58% olid duplikaadid — see moonutab kogu käibearuandlust.

Soovitus Toomasele
Kriitilisim domeen on müük (5116 duplikaati) ja hinnaebakõlad (664 rida) — alustada tuleb nende puhastamisest enne juhatuse koosolekut.

Puuduvad andmed
988 tehingul puudub kliendi seos — ei tea, kes need kliendid on ja kas nad on lojaalsed.

Ärianalüüs
Aktiveerimata kliendid
513 klienti on registreeritud emailiga kuid pole kunagi ostnud. Neile saab kohe saata UrbanStyle'i kampaaniakirja esmaostu allahindlusega — andmed on olemas, kampaania on käivitamisvalmis.

Puuduvad kontaktandmed
380 kliendil puudub e-mail — kuid kõigil on telefon olemas. SMS-kampaania kaudu saab pakkuda boonust e-maili lisamisel.

Hinna ebakõlad
664 ebakõla põhjus on selgitamata (allahindlus või andmeviga). Selgitamine võimalik N3-s promotions tabeliga JOIN-i abil.

Esitlus
Vaata esitlust PDF-ina
