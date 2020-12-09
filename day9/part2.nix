{ input ? import ./input.nix }:
let
  inherit (import ./part1.nix { inherit input; }) fault take drop;
  inherit (builtins) head tail elemAt length;
  inherit (import ../utils.nix) fix sum min max;
  output = fix (f: inputs: counter: let
    sumIn = sum inputs;
    first = min inputs;
    last = max inputs;
  in if sumIn == fault then first + last else
  if sumIn < fault then f (inputs ++ [(elemAt input counter)]) (counter + 1) else
  f (tail inputs) counter) [] 0;
in
  { inherit output; }

