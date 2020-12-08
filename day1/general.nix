{ input ? import ./input.nix, elements ? 3}:
let
  inherit (builtins) elem foldl' filter head map;
  inherit (import ../utils.nix) quickElem fix flatten sum product;
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

