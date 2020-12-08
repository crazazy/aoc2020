let
  inherit (builtins) attrNames elemAt foldl' filter fromJSON genList isString isInt length listToAttrs split;
in rec {
  fix = f: let x = f x; in x;
  # Especially useful if working with tuples (tuples in a semantic sense of course)
  quickElem = f: xs: let i = elemAt xs; in f i;
  charList = simpleSplit "";
  mod = a: b: if a < b then a else mod (a - b) b;
  simpleSplit = splitter: input: filter (x: isString x && x != "") (split splitter input);
  attrsToList = attrs: map (k: [k attrs.${k}]) (attrNames attrs);
  listToAttrs = list: listToAttrs (map (quickElem (i: {${i 0} = i 1;})) list);
  isIntStr = x: match "[0-9]+" x != null;
  toInt = string: let
    digitDict = {
      "0" = 0;
      "1" = 1;
      "2" = 2;
      "3" = 3;
      "4" = 4;
      "5" = 5;
      "6" = 6;
      "7" = 7;
      "8" = 8;
      "9" = 9;
    };
  in foldl' (a: b: 10*a + digitDict.${b}) 0 (charList string);

  # Folds
  flatten = foldl' (a: b: a ++ b) [];
  sum = foldl' (a: b: a + b) 0;
  product = foldl' (a: b: a * b) 1;
  any = foldl' (a: b: a || b) false;
  all = foldl' (a: b: a && b) true;
  min = foldl' (a: b: if a < b then a else b)  2147483647; # maxInt
  max = foldl' (a: b: if a > b then a else b) -2147483648; # minInt

  # In the case that we are going to work with the assembly code again
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
} 
