{ input ? builtins.readFile ./input }:
let
  inherit (builtins) split elem isList filter elemAt;
  inherit (import ../utils.nix) fix quickElem execute;
  lines = filter isList (split "(...) ([+-])([0-9]+)" input);
  output = elemAt (execute lines) 1;
in
  { inherit lines output; }
