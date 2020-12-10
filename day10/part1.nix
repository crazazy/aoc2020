{ input ? import ./input.nix}:
let
  inherit (builtins) length elemAt sort head tail;
  inherit (import ../utils.nix) fix max;
  sorted = [0] ++ (sort (a: b: a < b) input) ++ [(max input + 3)];
  output = fix (f: oneCount: threeCount: input: let
    e0 = elemAt input 0;
    e1 = elemAt input 1;
  in
  if length input == 1 then oneCount * threeCount else
  if e1 - e0 == 1 then f (oneCount + 1) threeCount (tail input) else
  if e1 - e0 == 3 then f oneCount (threeCount + 1) (tail input) else
  f oneCount threeCount (tail input) # pretty sure this part doesn't happen
  ) 0 0 sorted;
in
  { inherit sorted output; }
