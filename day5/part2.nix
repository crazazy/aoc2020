let
  inherit (import ./part1.nix {}) IDs;
  inherit (builtins) elemAt head foldl' sort tail;
  sortedIDs = sort (a: b: a < b) IDs;
  fix = f: let x = f x; in x;
  output = fix (f: list: let
    e0 = elemAt list 0;
    e1 = elemAt list 1;
  in
  if e1 - e0 == 2 then e0 + 1 else f (tail list)) sortedIDs;
in
  { inherit output sortedIDs; }
