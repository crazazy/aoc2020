{ input ? builtins.readFile ./input }:
let
  inherit (builtins) split elem fromJSON isList filter elemAt length;
  lines = filter isList (split "(...) ([+-])([0-9]+)" input);
  fix = f: let x = f x; in x;
  quickElem = f: xs: let i = elemAt xs; in f i;
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
  { inherit lines quickElem fix execute output; }
