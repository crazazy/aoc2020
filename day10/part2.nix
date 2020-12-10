{ input ? import ./input.nix }:
let
  inherit (import ./part1.nix { inherit input; }) sorted;
  inherit (import ../utils.nix) product fix max;
  inherit (builtins) head elemAt tail length filter toString;
  # the AoC input has number ranges of size 1-5, these all have a different amount of ways to be split up
  rangeOptions = range: {
    "1" = 1;
    "2" = 1;
    "3" = 2;
    "4" = 4;
    "5" = 7;
  }.${toString (length range)};
  ranges = fix (f: ranges: currentRange: input: let
    last = xs: elemAt xs (length xs - 1);
    comparator = last currentRange;
    e0 = head input;
  in
  if input == [] then ranges else
  if e0 - comparator == 1 then f ranges (currentRange ++ [e0]) (tail input) else
  f (ranges ++ [currentRange]) [e0] (tail input)) [] [0] (tail sorted);
  output = product (map rangeOptions ranges);
  in
{ inherit ranges output; }
