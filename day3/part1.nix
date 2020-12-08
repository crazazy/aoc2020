{ input ? builtins.readFile ./input }:
let
  inherit (builtins) filter length head split foldl';
  inherit (import ../utils.nix) quickElem mod simpleSplit charList;
  lines = simpleSplit "\n" input;
  chars = map charList lines;
  output = foldl' (a: quickElem (i: {
    pos = mod (a.pos + 3) (length (head chars));
    value = if i a.pos == "#" then a.value + 1 else a.value;
  })) {
    pos = 0;
    value = 0;
  } chars;
in
  output // { inherit chars lines mod quickElem; }
