-- cup constructor
-- take a floz and returna function that accepts a function to be applied to 
-- floz
cup floz = \message -> message floz

getFloz aCup = aCup (\floz -> floz)

-- creata a new cup with the drank value
drink aCup ozDrank = if ozDiff >= 0 then cup ozDiff else cup 0
  where
    floz   = getFloz aCup
    ozDiff = floz - ozDrank

-- see if a cup is empty
isEmpty aCup = getFloz aCup == 0


