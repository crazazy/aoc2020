{ input ? builtins.readFile ./input }:
let
  inherit (import ./part1.nix { inherit input; }) chars;
  inherit (import ../utils.nix) fix any sum;
  inherit (builtins) elemAt length head genList filter;
  coords = x: y: l: elemAt (elemAt l y) x;
  xmax = length (head chars) - 1;
  ymax = length chars - 1;
  directions = [[(-1) (-1)] [(-1) 0] [(-1) 1] [0 (-1)] [0 1] [1 (-1)] [1 0] [1 1]];
  charsToCoords = genList (y: genList (x: [x y (coords x y chars)]) (length (head chars))) (length chars);
  coordsToChars = map (map (x: elemAt x 2));
  neighborF = chars: coord: directions: let
    x = elemAt coord 0;
    y = elemAt coord 1;
    char = elemAt coord 2;
    found = elemAt (coords x y chars) 2;
    dx = elemAt directions 0;
    dy = elemAt directions 1;
    newx = x + dx;
    newy = y + dy;
  in if any [(x < 0) (x > xmax) (y < 0) (y > ymax)] then 0 else
  if found == "L" then 0 else
  if found == "#" then 1 else
  neighborF chars [newx newy char] directions;
  finalChars = coordsToChars (fix (f: coordChars: let
    neighbor = neighborF coordChars;
    updated = map (map (coord: let
      localx = elemAt coord 0;
      localy = elemAt coord 1;
      char = elemAt coord 2;
      transform = direction: let
        dx = elemAt direction 0;
        dy = elemAt direction 1;
      in [(localx + dx) (localy + dy) char];
      neighbors = sum (map (d: neighbor (transform d) d) directions);
    in if char == "#" && neighbors >= 5 then [ localx localy "L" ] else
    if char == "L" && neighbors == 0 then [ localx localy "#" ] else
    [ localx localy char ])) coordChars;
  in if coordChars == updated then coordChars else f updated) charsToCoords);
  output = sum (map (xs: length (filter (x: x == "#") xs)) finalChars);

in
  { inherit charsToCoords finalChars output; }
