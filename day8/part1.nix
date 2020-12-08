{ input ? builtins.readFile ./input }:
let
  inherit (builtins) split elem isList filter length fromJSON elemAt;
  inherit (import ../utils.nix) fix quickElem;
  lines = filter isList (split "(...) ([+-])([0-9]+)" input);
  execute = lines: fix (f: current: accumulator: pastOps: let
    ops = {
      nop = _: f (current + 1) (accumulator + 0) (pastOps ++ [current]);
      acc = x: f (current + 1) (accumulator + x) (pastOps ++ [current]);
      jmp = x: f (current + x) (accumulator + 0) (pastOps ++ [current]);
    };
    do = quickElem (i: let
      multiplier = if i 1 == "-" then -1 else 1;
      number = fromJSON (i 2);
    in ops.${i 0} (multiplier * number));
  in if current == length lines then [ true accumulator ] else
  if elem current pastOps then [ false accumulator ] else do (elemAt lines current)) 0 0 [];
 output = elemAt (execute lines) 1;
in
  { inherit lines output; }
