declare namespace v = "http://www.eki.ee/dict/fin";
declare namespace keeleleek = "http://www.keeleleek.ee/";

import module namespace functx = 'http://www.functx.com';

for $vastavus in fn:doc("./sõnad-ja-sufiksid.xml")/sõnad-ja-sufiksid/vastavus
  let $märksõna-sufiks := $vastavus/märksõna/sufiks
  group by $märksõna-sufiks
    return
      <vastavused>
        <märksõna-sufiks>{$märksõna-sufiks}</märksõna-sufiks>
          {
            for $vaste in $vastavus/vaste
              let $vaste-sufiks := $vaste/sufiks
              group by $vaste-sufiks
              return
                <vaste-sufiks arv="{count($vaste/sufiks[.=$vaste-sufiks])}">{$vaste-sufiks}</vaste-sufiks>
          }
      </vastavused>