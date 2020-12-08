{ input ? builtins.readFile ./input }:
let
  inherit (builtins) split isString foldl' filter match elem length;
  inherit (import ../utils.nix) simpleSplit sum;
  groups = simpleSplit "\n\n" input;
  answers = map (x: filter (y: match "[a-z]" y != null) (simpleSplit "" x)) groups;
  dedupAnswers = map (foldl' (a: b: if elem b a then a else a ++ [b]) []) answers;
  output = sum (map length dedupAnswers);
in
  { inherit groups simpleSplit sum output; }
