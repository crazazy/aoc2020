{ input ? import ./input.nix, elements ? 3}:
let
  inherit (builtins) elem elemAt foldl' filter head map;
  quickElem = f: xs: let i = elemAt xs; in f i;
  fix = f: let x = f x; in x;
  flatten = foldl' (a: b: a ++ b) [];
  sum = foldl' (a: b: a + b) 0;
  product = foldl' (a: b: a * b) 1;
  potentials = fix (f: left: potential:
    let
      new = 
        if potential == [] 
        then map (x: [x]) input
        else flatten (map (x: map (y: x ++ [y]) input) potential);
      newPotential = filter (x: sum x <= 2020) new;
    in
    if left <= 0 then potential else f (left - 1) newPotential) elements [];
  goals = filter (x: sum x == 2020) potentials;
  output = product (head goals);
in
  { inherit goals output potentials; }

