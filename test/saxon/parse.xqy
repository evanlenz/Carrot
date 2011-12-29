import module namespace p="Carrot" at "../../parser/Carrot.xqy";

declare variable $carrot-source external;

p:parse-Carrot(string($carrot-source))
