{ input ? import ./input.nix }:
let
  inherit (import ./part1.nix { inherit input; }) sorted;
  inherit (import ../utils.nix) product fix max;
  inherit (builtins) head elemAt tail length filter toString;
  # the AoC input has number ranges of size 1-5, these all have a different amount of ways to be split up
  trib = fix (f: a: b: c: n: if n == 1 then c else f b c (a + b + c) (n - 1)) 0 0 1;
  ranges = fix (f: ranges: currentRange: input: let
    last = xs: elemAt xs (length xs - 1);
    comparator = last currentRange;
    e0 = head input;
  in
  if input == [] then ranges else
  if e0 - comparator == 1 then f ranges (currentRange ++ [e0]) (tail input) else
  f (ranges ++ [currentRange]) [e0] (tail input)) [] [0] (tail sorted);
  output = product (map (x: trib (length x)) ranges);
  in
{ inherit ranges output; }
