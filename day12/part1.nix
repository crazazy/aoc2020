{ input ? builtins.readFile ./input }:
let
  inherit (builtins) filter isList split elemAt foldl' length fromJSON;
  inherit (import ../utils.nix) fix mod quickElem;
  navigation = filter isList (split "([A-Z])([0-9]+)" input);
  directions = ["E" "S" "W" "N"];
  # legend: [ x y direction ]
  initialPosition = [ 0 0 0 ];
  abs = x: if x < 0 then -1 * x else x;
  move = nav: quickElem (i: let
    x = i 0;
    y = i 1;
    dir = i 2;
    heading = elemAt nav 0;
    amount = fromJSON (elemAt nav 1);
    options = fix( self: {
      N = amount: [ x ( y - amount ) dir ];
      S = amount: [ x ( y + amount ) dir ];
      E = amount: [ ( x + amount ) y dir ];
      W = amount: [ ( x - amount ) y dir ];
      F = amount: self.${elemAt directions dir} amount;
      # our current version of mod doesn't support negative numbers :/
      L = amount: [ x y (mod (dir - (amount / 90) + (length directions)) (length directions)) ];
      R = amount: [ x y (mod (dir + (amount / 90)) (length directions)) ];
    });
  in
  options.${heading} amount);
  finalDestination = foldl' (a: b: move b a) initialPosition navigation;
  output = quickElem (i: (abs (i 0)) + (abs (i 1))) finalDestination;
in
  { inherit abs directions initialPosition finalDestination output navigation; }
