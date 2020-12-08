{ input ? builtins.readFile ./input }:
let
  inherit (builtins) filter foldl' head isString split tail;
  inherit (import ../utils.nix) max simpleSplit charList;
  lines = simpleSplit "\n" input;
  intList = map (string: map (x: if x == "B" || x == "R" then 1 else 0) (charList string) ) lines;
  IDs = map (foldl' (a: b: 2 * a + b) 0) intList;
  output = max IDs;
in
  { inherit lines IDs output; }

