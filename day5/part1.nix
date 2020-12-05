{ input ? builtins.readFile ./input }:
let
  inherit (builtins) filter foldl' head isString split tail;
  lines = filter (x: isString x && x != "") (split "\n" input);
  max = foldl' (a: b: if a > b then a else b) 0;
  charList = string: filter (x: isString x && x != "") (split "" string);
  intList = map (string: map (x: if x == "B" || x == "R" then 1 else 0) (charList string) ) lines;
  IDs = map (foldl' (a: b: 2 * a + b) 0) intList;
  output = max IDs;
in
  { inherit lines IDs output; }

