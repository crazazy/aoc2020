{ input ? builtins.readFile ./input }:
let
  inherit (builtins) filter length head split foldl' elemAt;
  quickElem = f: xs: let i = elemAt xs; in f i;
  mod = a: b: if a < b then a else mod (a - b) b;
  lines = filter (x: x != [] && x != null && x != "") (split "\n" input);
  charList = string: filter (x: x != [] && x != "") (split "" string);
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
