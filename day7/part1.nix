{ input ? builtins.readFile ./input }:
let
  inherit (builtins) elem listToAttrs length elemAt match split foldl' filter isList attrNames attrValues;
  quickElem = f: xs: let i = elemAt xs; in f i;
  fix = f: let x = f x; in x;
  flatten = foldl' (a: b: a ++ b) [];
  attrsToList = attrs: map (k: [k attrs.${k}]) (attrNames attrs);
  newListToAttrs = list: listToAttrs (map (quickElem (i: {${i 0} = i 1;})) list);
  inputs = filter (isList) (split "([a-z]+ [a-z]+) bags contains? (([0-9]+ [a-z ]+ bags?[,.] ?|no other bags\.)+)" input);
  bags = foldl' (a: quickElem (i: a // { ${i 0} = filter (isList) (split "([0-9]+) ([a-z ]+) bags?" (i 1)); })) {} inputs;
  # here the colors are just put in a single list
  bagsColors = foldl' (a: quickElem (i: a // { ${i 0} = flatten (filter (isList) (split "[0-9]+ ([a-z ]+) bags?" (i 1))); })) {} inputs;
  colors = attrNames bagsColors;
  any = foldl' (a: b: a || b) false;
  hasShinyGold = fix (f: colors: bags: let
    newColors = foldl' (a: quickElem (i: if !(elem (i 0) colors) && (any (map (x: elem x colors) (i 1))) then a ++ [(i 0)] else a)) [] bags;
  in if newColors == [] then colors else f (colors ++ newColors) bags) ["shiny gold"] (attrsToList bagsColors);
  output = (length hasShinyGold) - 1;
in
  {inherit fix quickElem colors inputs bags bagsColors hasShinyGold output;}
