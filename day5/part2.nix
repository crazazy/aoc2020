{ input ? builtins.readFile ./input}:
let
  inherit (import ./part1.nix { inherit input; }) IDs;
  inherit (builtins) elemAt head foldl' sort tail;
  inherit (import ../utils.nix) fix;
  sortedIDs = sort (a: b: a < b) IDs;
  output = fix (f: list: let
    e0 = elemAt list 0;
    e1 = elemAt list 1;
  in
  if e1 - e0 == 2 then e0 + 1 else f (tail list)) sortedIDs;
in
  { inherit output sortedIDs; }
