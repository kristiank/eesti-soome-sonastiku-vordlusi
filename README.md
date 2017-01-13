# Eesti-soome võrdlusi sõnaraamatus

Talvel 2016/2017 Tartu Ülikooli aine Soome-eesti kontrastiivgrammatika jaoks koostatud lihtsaid statistikaid. Analüüsitud andmestik pärineb EKIs koostamisejärgus olevast suurest eesti-soome sõnaraamatust.

Statistika koostavad XQuery-päringud ja nende koostatud andmestikud on siinkohal avaldatud. Sõnastiku algandmed ei ole avaldatud.

Hiljem lisandub veel statistikaid ja andmestikke ning graafilised kokkuvõtud.

## Kokkulangevate sõnalõppude lugemine eesti-soome sõnaraamatus

Statistika võrdleb märksõna ja selle vastete sõnalõppusid. Kuna sõnalõpud kajastavad mõlema keele morfoloogiat, saab statistika kaudu kontrastiivse ülevaate keelte semantilises vastavuses olevate sõnade ehitusest.

Protseduur viiakse läbi järgmiselt:
```
iga eesti märksõna
  iga soome vaste
    leitakse pikimalt kokkulangev sõnalõpp
      ja salvestatakse
        <märksõna>
          <m>$m</m>
          <vaste>
            <lõpp>$matching-end</lõpp>
            <arv>$count</arv>
          </vaste>
        </märksõna>
```


## Eesti õ vasted

Eesti silpide, kus esineb õ, vastavad silbid soome keele sõnadest. Grafeem õ võis esineda üksinda, pikana või diftongina.

Protseduur viiakse läbi järgmiselt:
```
iga eesti märksõna, kus esineb õ
  käsitsi määratud eesti sõna silp
  käsitsi määratud vastav soome silp
```
