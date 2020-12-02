{ input ? builtins.readFile ./input }:
let
  inherit (builtins) filter foldl' match map elemAt split;
  charList = string: filter (x: x != [] && x != "") (split "" string);
  quickElem = f: xs: let i = elemAt xs; in f i;
  passwordPairs = filter (x: x != []) (split "\n" input);
  # parse the passwords into different sections
  passwords = filter (x: x != null ) (map (x: match "([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)" x) passwordPairs);
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
  toInt = string: foldl' (a: b: 10*a + digitDict.${b}) 0 (charList string);
  parsedPasswords = map (quickElem (i: [
    (toInt (i 0))
    (toInt (i 1))
    (i 2)
    (i 3)])) passwords;
  isValid = quickElem (i: let
    min = i 0;
    max = i 1;
    char = i 2;
    password = charList (i 3);
    charCount = foldl' (a: x: if x == char then a + 1 else a) 0 password;
  in
  min <= charCount && max >= charCount);
  output = foldl' (a: x: if isValid x then a + 1 else a) 0 parsedPasswords;

in
  { inherit quickElem charList parsedPasswords output; }
