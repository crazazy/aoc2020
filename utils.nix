let
  inherit (builtins) attrNames elem elemAt foldl' filter fromJSON genList head isString isInt length listToAttrs match split tail;
in rec {
  fix = f: let x = f x; in x;
  # Especially useful if working with tuples (tuples in a semantic sense of course)
  quickElem = f: xs: let i = elemAt xs; in f i;
  enumerate = xs: genList (x: [x (elemAt xs x)]) (length xs);
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
  min = xs: foldl' (a: b: if a < b then a else b) (head xs) (tail xs); # maxInt
  max = xs: foldl' (a: b: if a > b then a else b) (head xs) (tail xs); # minInt/2
}
