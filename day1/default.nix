# use `nix eval -f ./default.nix -I 'input=<input file>' output` to view output
let
  inherit (builtins) elem elemAt filter length map toString toFile;
  input = import <input>;
  negatives = map (x: 2020 - x) input;
  pair = filter (x: elem x negatives) input;
  output = elemAt pair 0 * elemAt pair 1;
in
  { inherit output pair; }

