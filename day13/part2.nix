{ input ? builtins.readFile ./input }:
let
  inherit (import ./part1.nix { inherit input; }) data busNumbers;
  inherit (import ../utils.nix) fix product mod take lcm;
  inherit (builtins) elemAt genList length foldl' filter isList split head tail;
  busStrings = map head (filter isList (split "(x|[0-9]+)" data.busString));
  offsets = filter (x: elemAt busStrings x != "x") (genList (x: x) (length busStrings));
  period = foldl' lcm 1 busNumbers;
  zipWith = f: xs: ys:
  let
    x = head xs;
    y = head ys;
  in
  if xs == [] then [] else
  if ys == [] then [] else
  [(f x y)] ++ zipWith f (tail xs) (tail ys);
  combos = zipWith (x: y: [ x y ]) busNumbers offsets;
  start = head busNumbers;
  match = fix (f: number: idx: let
    current = elemAt combos idx;
    updated = number + (product (take idx busNumbers));
    bus = elemAt current 0;
    offset = elemAt current 1;
    trueOffset = mod offset bus;
    check = mod (number - trueOffset) bus == 0;
  in
  if (length combos) == idx then number else
  if check then f number (idx + 1) else
  f updated idx) start 1;
  output = period - (mod match period);
in
  { inherit busStrings period offsets output; }
