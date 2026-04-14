--Kokkuvõte:

Mina uurisin kliendiandmete tabelit, kus oli 3150 rida ja 9 veergu. 
Koheselt jääb silma, et:
•	enamus andmeid on veergudes olemas
•	veergudes „email“ ja „loyalty_tier“ on puuduvaid andmeid
•	veerus „city“ on andmed ebakorrektsed: linnanimed on erineva kirjapildiga (suured ja väikesed tähed) ning esineb liigseid tühikuid
 (nt nime ees või järel)

-- Kokku on 3150 klienti, dubleerivaid ei olnud. Kliendi andmetest olid kõik eesnimed olemas, samas puuduvaid e-maile oli 380 (12,1%) ning dubleerivaid e-maile oli 510 (16,2%) ja unikaalseid emaile 2640 (71,7%)
-- Millistest linnadest kliendi on?
Päringut kasutades selgus, et linnade väärtused ei ole samad. Sama linn esineb erineval kujul (nt suur- ja väiketähed, tühikud), mistõttu DISTINCT käsitleb neid eraldi väärtusena.

--Üllatav oli see, et kõik eesnimed olid olemas, samas oli puuduvaid e-maile.

--Edasiseks analüüsiks tuleks esmalt kontrollida kliendikaardi (customer_id) sisu, nt nimi ja e-mail, et tuvastada võimalikud samad kliendid.
- Tuleks korrastada ka puuduolevad andmed.

