(: Carrot parser invocation script for MarkLogic Server. :)

(:
   Assuming an app server with the root set to this source tree,
   invoke this script via HTTP, e.g.:

   http://localhost:8020/parser/parse.xqy?file=parser/test.crt
:)

declare variable $input-file := xdmp:get-request-field("file");

declare variable $file-path := concat(xdmp:modules-root(),$input-file);

declare variable $carrot-string := 
string(
  xdmp:document-get($file-path,
    <options xmlns="xdmp:document-get">
      <format>text</format>
    </options>)
);

declare variable $parse-string := concat('{', $carrot-string, '}');

xdmp:invoke("Carrot.xqy", (xs:QName("input"), $parse-string))
