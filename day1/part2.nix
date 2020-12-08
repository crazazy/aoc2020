{ input ? import ./input.nix }:
# to run, use `nix eval -f ./part2.nix -I 'input=./input.nix' output`
let
  inherit (builtins) elem head map filter tail;
  inherit (import ../utils.nix) flatten fix quickElem;
  sorted = builtins.sort builtins.lessThan input;
  allPairs = flatten (map (x: map (y: [x y]) sorted) sorted);
  positives = filter (quickElem (i: i 0 > i 1)) allPairs;
  positives2 = filter (quickElem (i: i 0 + i 1 < 2020)) allPairs;
  allTriplets = flatten (map (x: map (y: x ++ [y]) sorted) positives2);
  triplets = filter (quickElem (i: (i 0 + i 1 + i 2) == 2020)) allTriplets;
  output = quickElem (i: i 0 * i 1 * i 2) (head triplets);
in
  { inherit allPairs triplets output; }

