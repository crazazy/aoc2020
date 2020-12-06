{ input ? builtins.readFile ./input }:
let
  inherit (builtins) split isString foldl' filter match elem length;
  simpleSplit = splitter: input: filter (x: isString x && x != "") (split splitter input);
  groups = simpleSplit "\n\n" input;
  answers = map (x: filter (y: match "[a-z]" y != null) (simpleSplit "" x)) groups;
  dedupAnswers = map (foldl' (a: b: if elem b a then a else a ++ [b]) []) answers;
  sum = foldl' (a: b: a + b) 0;
  output = sum (map length dedupAnswers);
in
  { inherit groups simpleSplit sum output; }
