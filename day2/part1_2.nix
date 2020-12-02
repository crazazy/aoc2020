{ input ? builtins.readFile ./input }:
let
  inherit (builtins) filter foldl' fromJSON isList match map elemAt split;
  charList = string: filter (x: x != [] && x != "") (split "" string);
  quickElem = f: xs: let i = elemAt xs; in f i;
  passwordPairs = filter (x: x != []) (split "\n" input);
  # parse the passwords into different sections
  passwords = filter isList (split "([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)" input);
  parsedPasswords = map (quickElem (i: [
    (fromJSON (i 0))
    (fromJSON (i 1))
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
