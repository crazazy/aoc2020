{ input ? builtins.readFile ./input }:
let
  inherit (import ./part1.nix { inherit input; }) chars mod quickElem;
  inherit (builtins) elemAt foldl' head length;
  product = foldl' (a: b: a * b) 1;
  calculateTrees = tuple: let
    j = elemAt tuple;
    right = j 0;
    down = j 1;
  in
  foldl' (a: quickElem (i:
    if a.down > 1 then a // { down = a.down - 1; }
    else {
      inherit down;
      pos = mod (a.pos + right) (length (head chars));
      value = if i a.pos == "#" then a.value + 1 else a.value;
    })) {
      pos = 0;
      down = 1;
      value = 0;
    } chars;
  outList = map calculateTrees [[1 1] [3 1] [5 1] [7 1] [1 2]];
  output = product (map (x: x.value ) outList);
in
  { inherit outList output; }

