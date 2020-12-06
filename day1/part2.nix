{ input ? import ./input.nix }:
# to run, use `nix eval -f ./part2.nix -I 'input=./input.nix' output`
let
  inherit (builtins) elem elemAt foldl' head map filter tail;
  flatten = xs: foldl' (a: b: a ++ b) [] xs;
  fix = f: let x = f x; in x;
  sorted = builtins.sort builtins.lessThan input;
  quickElem = f: xs: let i = elemAt xs; in f i;
  allPairs = flatten (map (x: map (y: [x y]) sorted) sorted);
  positives = filter (quickElem (i: i 0 > i 1)) allPairs;
  positives2 = filter (quickElem (i: i 0 + i 1 < 2020)) allPairs;
  allTriplets = flatten (map (x: map (y: x ++ [y]) sorted) positives2);
  triplets = filter (quickElem (i: (i 0 + i 1 + i 2) == 2020)) allTriplets;
  output = quickElem (i: i 0 * i 1 * i 2) (head triplets);
in
  { inherit allPairs triplets output; }

