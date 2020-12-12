{ input ? builtins.readFile ./input }:
let
  inherit ( import ../utils.nix ) fix sum quickElem;
  inherit (import ./part1.nix { inherit input; }) navigation directions initialPosition abs;
  inherit (builtins) length fromJSON foldl' elemAt;
  initialWaypoint = [ 10 (-1) ];
  move = nav: position: let
    waypoint = elemAt position 0;
    coord = elemAt position 1;
    heading = elemAt nav 0;
    amount = fromJSON (elemAt nav 1);
    wx = elemAt waypoint 0;
    wy = elemAt waypoint 1;
    x = elemAt coord 0;
    y = elemAt coord 1;
    dir = elemAt coord 2;
    options = {
      N = [ [ wx (wy - amount) ] coord ];
      S = [ [ wx (wy + amount) ] coord ];
      E = [ [ (wx + amount) wy ] coord ];
      W = [ [ (wx - amount) wy ] coord ];
      F = [ waypoint [ (x + amount * wx) (y + amount * wy) dir ] ];
      L = if amount == 0 then [ waypoint coord ] else 
      (move ["L" (toString (amount - 90))] [ [ wy (-wx) ] coord ]);
      R = if amount == 0 then [ waypoint coord ] else 
      (move ["R" (toString (amount - 90))] [ [ (-wy) wx ] coord ]);
    };
  in options.${heading};
  finalDestination = foldl' (a: b: move b a) [ initialWaypoint initialPosition ] navigation;
  output = quickElem (i: sum (map abs (i 1))) finalDestination;
in
  { inherit finalDestination output; }
