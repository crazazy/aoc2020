{ input ? import ./input.nix}:
let
  inherit (builtins) elem head tail;
  inherit (import ../utils.nix) fix any;
  sumCheck = inputs: result: let
    negatives = map (x: result - x) inputs;
  in any (map (x: elem x negatives) inputs);
  take = n: xs: if n == 0 then [] else [(head xs)] ++ take (n - 1) (tail xs);
  drop = n: xs: if n == 0 then xs else drop (n - 1) (tail xs);
  output = fix (f: input: let
    preamble = take 25 input;
    check = head (drop 25 input);
  in if !(sumCheck preamble check) then check else f (tail input)) input;
in
  { 
    inherit take drop sumCheck output;
    fault = output;
  }

