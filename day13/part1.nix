{ input ? builtins.readFile ./input }:
let
  inherit (builtins) foldl' filter head isList fromJSON split;
  inherit (import ../utils.nix) mod quickElem simpleSplit min;
  lines = simpleSplit "\n" input;
  data = quickElem (i: {
    timeStamp = fromJSON (i 0);
    busses = filter isList (split "([0-9]+)" (i 1));
    busString = i 1;
  }) lines;
  busNumbers = map (x: fromJSON (head x)) data.busses;
  busInfo = (foldl' (a: b:
  let
    arrivesIn = b - mod data.timeStamp b;
  in
  if a.lowest > arrivesIn
  then { lowest = arrivesIn; bus = b; } 
  else a) 
  { bus = 0; lowest = 1000; } busNumbers);
  output = busInfo.lowest * busInfo.bus;
in
  { inherit data busNumbers output; }
