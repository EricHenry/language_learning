

add3ToAll []       = []
add3ToAll (x : xs) = (3 + x) : add3ToAll xs

mul2ByAll []       = []
mul2ByAll (x : xs) = (3 * x) : mul2ByAll xs


myMap _ []       = []
myMap f (x : xs) = f x : myMap f xs

myFilter _ [] = []
myFilter predicate (x : xs) =
    if predicate x then x : myFilter predicate xs else myFilter predicate xs



remove _ [] = []
remove predicate (x : xs) =
    if predicate x then myFilter predicate xs else x : myFilter predicate xs

myProduct xs = foldl (*) 1 xs

rcons x y = y : x
myReverse xs = foldl rcons [] xs

myFoldl f init []       = init
myFoldl f init (x : xs) = myFoldl f newInit xs where newInit = f init x

myFoldr f init []       = init
myFoldr f init (x : xs) = f x rightResult
    where rightResult = myFoldr f init xs


-- Q 9.1
-- use filter and length to recreate the elem function
myElem val aList = (length filteredList) /= 0
    where filteredList = filter (== val) aList


-- Q 9.2
isPalindrome words = cleanedWords == reverse cleanedWords
  where
    noSpaces     = filter (/= " ") noSpaces
    cleanedWords = map toLower noSpaces


-- Q 9.3
harmonic n = sum (take n seriesValues)
  where
    seriesPairs  = zip (cycle [1.0]) [1.0, 2.0 ..]
    seriesValues = map (\pair -> (fst pair) / (snd pair)) seriesPairs
