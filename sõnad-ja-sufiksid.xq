declare namespace v = "http://www.eki.ee/dict/fin";
declare namespace keeleleek = "http://www.keeleleek.ee/";

import module namespace functx = 'http://www.functx.com';

declare function keeleleek:parim-kokkulangevus
  ($est as xs:string, $fin as xs:string)
  {
    <etc>{
      for $char-pos in reverse(1 to string-length($est))
        let $substring-expression := concat(functx:escape-for-regex(fn:substring($est, $char-pos)), ".?$")
        return
          if(fn:matches($fin, $substring-expression))
          then($substring-expression)
          else()
    }</etc>
  };


(:~ 
 : Tests whether a word ends with an Estonian suffix.
 : Returns the longest matching suffix or false().
 : 
 : @param $word the word to test
 : @return xs:string or false()
 :)
declare function keeleleek:ends-with-est-suffix($word as xs:string)
{
  let $est-suffixes := 
    <suffixes>
      <suffix>taoline</suffix>
      <suffix>line</suffix>
      <suffix>ne</suffix>
      <suffix>lik</suffix>
      <suffix>likkus</suffix>
      <suffix>us</suffix>
      <suffix>sugune</suffix>
      <suffix>võitu</suffix>
      <suffix>lane</suffix>
      <suffix>matu</suffix>
      <suffix>tu</suffix>
      <suffix>ta</suffix>
      <suffix>ev</suffix>
      <suffix>kas</suffix>
      <suffix>jas</suffix>
      <suffix>rikas</suffix>
      <suffix>mine</suffix>
      <suffix>ur</suffix>
      <suffix>ga</suffix>
      <suffix>ja</suffix>
    </suffixes>
  
  return
    keeleleek:ends-with-suffix($word, $est-suffixes)
};


(:~ 
 : Tests whether a word ends with a Finnish suffix.
 : Returns the longest matching suffix or false().
 : 
 : @param $word the word to test
 : @return xs:string or false()
 :)
declare function keeleleek:ends-with-fin-suffix($word as xs:string)
{
  let $est-suffixes := 
    <suffixes>
      <suffix>linen</suffix>
      <suffix>nen</suffix>
      <suffix>[aä]s</suffix>
      <suffix>l[oö]inen</suffix>
      <suffix>k[oö]inen</suffix>
      <suffix>is[aä]</suffix>
      <suffix>läntä</suffix>
      <suffix>hk[oö]</suffix>
      <suffix>e[aä]</suffix>
      <suffix>likk[oö]</suffix>
      <suffix>lisyys</suffix>
      <suffix>syys</suffix>
      <suffix>lainen</suffix>
      <suffix>m[aoö]inen</suffix>
      <suffix>t[oö]n</suffix>
      <suffix>m[aä]t[oö]n</suffix>
      <suffix>j[aä]</suffix>
    </suffixes>
  
  return
    keeleleek:ends-with-suffix($word, $est-suffixes)
};


(:~ 
 : General function that tests whether a word ends with any suffix given in a suffixes list.
 : Returns the longest matching suffix or an empty string.
 : 
 : @param $word the word to test
 : @param $suffixes element with list of suffixes to match
 : @return xs:string
 :)
declare function keeleleek:ends-with-suffix($word as xs:string, $suffixes as element(suffixes))
as xs:string
{
  let $suffix-regexp := concat(
    "(.*?)(",
    string-join($suffixes/suffix/text(), "|"),
    ")$"
  )
  let $matching-suffix := replace($word, $suffix-regexp, "$2")
  return
    if($matching-suffix = $word)
    then("MUU")
    else($matching-suffix)
};



declare function keeleleek:sõna-ja-sufiks($sõna as xs:string, $keel as xs:string)
as xs:string
{
  let $sufiks := 
    if($keel = "est")
    then(keeleleek:ends-with-est-suffix($sõna))
    else if($keel = "fin")
      then(keeleleek:ends-with-fin-suffix($sõna))
      else()
      
  return
    if(string-length($sufiks) = 0)
    then()
    else(
        <sõna>{$sõna}</sõna>,
        <sufiks>{$sufiks}</sufiks>
    )
};


<sõnad-ja-sufiksid>{
for $A in (db:open('fin')//v:A[exists(.//v:m) and exists(.//v:x)]) (:[fn:position() < 500]:)
  for $m in $A//v:m (: @todo limit by part of speech :)
    let $märksõna := $m/string()
    let $märksõna-sufiks := keeleleek:ends-with-est-suffix($märksõna)
    let $vastavus :=
      <vastavus>
        <märksõna>
          <sõna>{$märksõna}</sõna>
          <sufiks>{keeleleek:ends-with-est-suffix($märksõna)}</sufiks>
        </märksõna>
        {
          for $x in $A//v:x[string-length(.) != 0]
            let $vastesõna := $x/string()
            let $vastesõna-sufiks := keeleleek:ends-with-fin-suffix($vastesõna)
            
            return
              if(string-length($vastesõna-sufiks) = 0)
              then()
              else(
                <vaste>
                  <sõna>{$vastesõna}</sõna>
                  <sufiks>{keeleleek:ends-with-fin-suffix($vastesõna)}</sufiks>
                </vaste>
              )
        }
      </vastavus>
      
    return
      if(exists($vastavus/märksõna/sufiks/text())
         and exists($vastavus/vaste/sufiks/text()
         and $vastavus/märksõna/sufiks/text() != "MUU"
         and $vastavus/vaste/sufiks/text() != "MUU"))
      then($vastavus)
      else()

}</sõnad-ja-sufiksid>