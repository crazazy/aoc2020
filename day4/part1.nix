{ input ? builtins.readFile ./input }:
let
  inherit (builtins) split foldl' elem length isString isList filter;
  flatten = foldl' (a: b: a ++ b) [];
  oneOf = foldl' (a: b: a || b) false;
  all = foldl' (a: b: a && b) true;
  lines = filter (s: s != "" && isString s) (split "\n\n" input);
  prefixes =  (map (x: filter isList (split "(...):"  x)) lines);
  hasRequiredPrefixes = filter (x: all (map (y: elem [y] x) ["byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"])) prefixes;
  output = length hasRequiredPrefixes;
in
  { inherit all oneOf lines output; }

