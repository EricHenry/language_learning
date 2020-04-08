import           Data.List

names =
    [ ("Ian"    , "Curtis")
    , ("Bernard", "Sumner")
    , ("Peter"  , "Hook")
    , ("Stephen", "Morris")
    ]

compareLastName name1 name2 = if lastName1 > lastName2
    then GT
    else if lastName1 < lastName2
        then LT
        else if firstName1 > firstName2
            then GT
            else if firstName1 < firstName2 then LT else EQ
  where
    lastName1  = snd name1
    lastName2  = snd name2
    firstName1 = fst name1
    firstName2 = fst name2

compareLastName2 name1 name2 = if result == EQ
    then compare (fst name1) (fst name2)
    else result
    where result = compare (snd name1) (snd name2)

addressLetter name location = nameText ++ " - " ++ location
    where nameText = (fst name) ++ " " ++ (snd name)


isEven fn n = if even n then fn n else n

isEvenCubed n = isEven (\x -> x ^ 3) n
