{ input ? builtins.readFile ./input}:
let
  inherit (import ./part1.nix { inherit input; }) lines;
  inherit (builtins) filter genList foldl' elemAt length;
  inherit (import ../utils.nix) enumerate fix quickElem execute;
  output = fix (f: current: let
    isAcc = quickElem (i: i 0 == "acc") (elemAt lines current);
    update = quickElem (i: if i 0 == "nop" then ["jmp" (i 1) (i 2)] else ["nop" (i 1) (i 2)]);
    modifiedLines = map (quickElem (i: if i 0 == current then update (i 1) else (i 1))) (enumerate lines);
  in if isAcc then f (current + 1) else quickElem (i: if i 0 then i 1 else f (current + 1)) (execute modifiedLines)) 0;
in
  { inherit output; }
