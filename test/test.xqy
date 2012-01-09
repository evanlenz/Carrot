(: Carrot parser invocation script for MarkLogic Server. :)

(:
   Assuming an app server with the root set to this source tree,
   invoke this script via HTTP, e.g.:

   Show parsed result:
   http://localhost:8020/test/test.xqy?carrot=test/01/test.crt

   Show compiled result:
   http://localhost:8020/test/test.xqy?carrot=test/01/test.crt&compile=yes

   Show executed result:
   http://localhost:8020/test/test.xqy?carrot=test/01/test.crt&source=test/01/test.xml
:)

import module namespace p="Carrot" at "../parser/Carrot.xqy";

declare variable $carrot-file := xdmp:get-request-field("carrot");
declare variable $source-file := xdmp:get-request-field("source");

declare variable $carrot-file-path := concat(xdmp:modules-root(),$carrot-file);
declare variable $source-file-path := concat(xdmp:modules-root(),$source-file);

declare variable $compile := xdmp:get-request-field("compile");

declare variable $carrot-string := 
string(
  xdmp:document-get($carrot-file-path,
    <options xmlns="xdmp:document-get">
      <format>text</format>
    </options>)
);

declare variable $source-doc := xdmp:document-get($source-file-path);

declare variable $parse-result := p:parse-Carrot($carrot-string);

declare variable $compiled-result := xdmp:xslt-invoke("../compiler/compile.xsl", document{$parse-result});

     if (string($source-file)) then xdmp:xslt-eval($compiled-result, $source-doc)
else if ($compile eq 'yes')    then ($compiled-result, xdmp:set-response-content-type("text/xml"))
                               else $parse-result
