let
  inherit (import ./part1.nix {}) all oneOf lines;
  inherit (builtins) attrNames deepSeq elem elemAt filter foldl' fromJSON isInt isList length match split stringLength substring tryEval;
  quickElem = f: xs: let i = elemAt xs; in f i;
  isIntStr = x: match "[0-9]+" x != null;
  data = map (x: filter isList (split "(...):([^ \n]+)" x)) lines;
  # use fromJSON for parsing integers.
  verifiers = {
    byr = str: let
      int = fromJSON str;
    in isIntStr str && (int >= 1920 && int <= 2002);
    iyr = str: let
      int = fromJSON str;
    in isIntStr str && (int >= 2010 && int <= 2020);
    eyr = str: let
      int = fromJSON str;
    in isIntStr str && (int >= 2020 && int <= 2030);
    hgt = str: let
      substrLen = (stringLength str) - 2;
      substr = substring 0 substrLen str;
      len = fromJSON substr;
    in
    if !(isIntStr substr) then false else
    if (match ".*in" str != null) then len >= 59 && len <= 76 else
    if (match ".*cm" str != null) then len >= 150 && len <= 193 else
    false;
    hcl = str: (match "#([0-9a-f]{6})" str) != null;
    ecl = str: oneOf (map (y: y == str) ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"]);
    pid = str: (match "[0-9]{9}" str) != null;
    cid = str: true;
  };
  hasAllPrefixes = entry: foldl' (a: quickElem (i: if elem (i 0) (filter (x: x != "cid") (attrNames verifiers)) then a + 1 else a)) 0 entry >= 7;
  verify = entry: all (map (quickElem (i: verifiers.${i 0} (i 1))) entry);
  correctEntries = filter (x: verify x && hasAllPrefixes x) data;
  output = length correctEntries;

in
  { inherit data correctEntries output; }
