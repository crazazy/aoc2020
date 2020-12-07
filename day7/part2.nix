{ input ? builtins.readFile ./input}:
let
  inherit (import ./part1.nix { inherit input; }) bags colors fix quickElem;
  inherit (builtins) elem elemAt filter foldl' fromJSON;
  sum = foldl' (a: b: a + b) 0;
  bagCount = fix (f: color: let
    innerBagCount = sum (map (quickElem (i: (fromJSON (i 0)) * (f (i 1)))) bags.${color});
  in 1 + (if elem color colors then innerBagCount else 0)) "shiny gold";
  output = bagCount - 1;
in
  { inherit bags output; }
