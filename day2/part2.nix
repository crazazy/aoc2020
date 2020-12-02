let
  inherit (builtins) elemAt foldl' tryEval;
  inherit (import ./part1.nix {}) quickElem charList parsedPasswords;
  isValid = quickElem (i: let
    fst = (i 0) - 1;
    snd = (i 1) - 1;
    char = i 2;
    password = charList (i 3);
    xor = a: b: a && !b || !a && b;
    # account for OOB error
  in
    (xor ((elemAt password fst) == char) ((elemAt password snd) == char)));
  output = foldl' (a: x: if isValid x then a + 1 else a) 0 parsedPasswords;
in
  { inherit parsedPasswords output; }
