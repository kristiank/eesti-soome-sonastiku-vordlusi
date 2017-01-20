declare namespace v = "http://www.eki.ee/dict/ss";


let $adjektiivid := distinct-values(db:open("ekss")//v:A[exists(.//v:sl[. = "adj"])]//v:m/string())
let $kõik-sõnad := distinct-values(db:open("ekss")//v:m/string())

for $adjektiiv in $adjektiivid
  (:let $esineb-afiksina := $adjektiivid[contains(., $adjektiiv)]:)
  let $esineb-afiksina := $kõik-sõnad[contains(., $adjektiiv)]
  return
    if(count($esineb-afiksina) > 1)
    then(<grupp>
            {concat($adjektiiv,
                          ": ",
                          string-join($esineb-afiksina, ", ")
                        )
            }</grupp>)
    else()