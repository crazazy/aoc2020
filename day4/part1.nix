{ input ? builtins.readFile ./input }:
let
  inherit (builtins) split foldl' elem length isString isList filter;
  inherit (import ../utils.nix) flatten any all;
  lines = filter (s: s != "" && isString s) (split "\n\n" input);
  prefixes =  (map (x: filter isList (split "(...):"  x)) lines);
  hasRequiredPrefixes = filter (x: all (map (y: elem [y] x) ["byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"])) prefixes;
  output = length hasRequiredPrefixes;
in
  { inherit all any lines output; }

