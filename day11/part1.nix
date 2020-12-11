{ input ? builtins.readFile ./input, seats ? 4 }:
let
  inherit (builtins) concatStringsSep foldl' genList elemAt length head tail filter;
  inherit (import ../utils.nix) simpleSplit fix charList take drop sum;
  shiftUp = xs: tail xs ++ [(genList (_: 0) (length (head xs)))];
  shiftDown = xs: [(genList (_: 0) (length (head xs)))] ++ take (length xs - 1) xs;
  shiftLeft = map (x: tail x ++ [0]);
  shiftRight = map (x: [0] ++ take (length x - 1) x);
  zipWith = f: xs: ys: let
    x = head xs;
    y = head ys;
  in if xs == [] then [] else
  if ys == [] then [] else
  [(f x y)] ++ zipWith f (tail xs) (tail ys);
  lines = simpleSplit "\n" input;
  chars = map charList lines;
  charsToInts = map (map (x: {"#" = 1; "L" = 0; "." = -1;}.${x}));
  intsToChars = map (map (x: elemAt ["." "L" "#"] (x + 1)));
  neighbours = xs: let
    up = shiftUp xs;
    down = shiftDown xs;
    left = shiftLeft xs;
    right = shiftRight xs;
    upleft = shiftLeft up;
    downleft = shiftLeft down;
    upright = shiftRight up;
    downright = shiftRight down;
    combineSingleList = zipWith (x: y: let
      newX = if x == -1 then 0 else x;
      newY = if y == -1 then 0 else y;
    in newX + newY);
    combineListList = zipWith combineSingleList;
  in foldl' combineListList up [ down left right upleft downleft upright downright ];
  finalChairs = intsToChars (fix (f: chairs: let
    chairsNeighbours = neighbours chairs;
    coords = x: y: l: elemAt (elemAt l y) x;
    rangeY = genList (x: x) (length chairs);
    range = map (y: genList (x : [x y]) (length (head chairs))) rangeY;
    updated = map (map (pair: let
      e0 = elemAt pair 0;
      e1 = elemAt pair 1;
      coord = coords e0 e1;
    in if (coord chairs) == -1 then -1 else
    if (coord chairsNeighbours) == 0 && (coord chairs == 0) then 1 else
    if (coord chairsNeighbours) >= seats && (coord chairs == 1) then 0 else
    coord chairs)) range;
  in if updated == chairs then chairs else f updated) (charsToInts chars));
  chairsNeighbours = neighbours chars;
  finalChairString = concatStringsSep "\n" (map (concatStringsSep "") finalChairs);
  output = sum (map (xs: length (filter (x: x == "#") xs)) finalChairs);
in
  { inherit chars finalChairs chairsNeighbours output finalChairString; }
