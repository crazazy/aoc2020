{ input ? import ./input.nix}:
let
  inherit (builtins) elem head tail;
  inherit (import ../utils.nix) fix any take drop;
  sumCheck = inputs: result: let
    negatives = map (x: result - x) inputs;
  in any (map (x: elem x negatives) inputs);
  output = fix (f: input: let
    preamble = take 25 input;
    check = head (drop 25 input);
  in if !(sumCheck preamble check) then check else f (tail input)) input;
in
  { 
    inherit take drop sumCheck output;
    fault = output;
  }

