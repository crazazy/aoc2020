{ input ? builtins.readFile ./input}:
let
  inherit (builtins) foldl' length match head tail elem;
  inherit (import ./part1.nix { inherit input; }) groups simpleSplit sum;
  answers = map (group: let
    people = simpleSplit "\n" group;
    initial = head people;
    # asnwers that a single person gave
    answers = simpleSplit "";
    check = tail people;
    all = foldl' (a: b: a && b) true;
  in
  foldl' (a: b: if all (map (x: elem b (answers x)) check) then a ++ [b] else a) [] (answers initial)) groups;
  output = sum (map length answers);
in
  { inherit output answers; }
