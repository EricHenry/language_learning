
ifEven f x = if even x then f x else x

genIfXEven x = (\f -> ifEven f x)

getRequestURL host apiKey resource id =
    host ++ "/" ++ resource ++ "/" ++ id ++ "?token=" ++ apiKey

genHostRequestBuilder host =
    (\apiKey resource id -> getRequestURL host apiKey resource id)

exampleUrlBuilder = genHostRequestBuilder "http://example.com"

genApiRequestBuilder hostBuilder apiKey =
    (\resource id -> hostBuilder apiKey resource id)

genApiRequestBuilder2 hostBuilder apiKey resource =
    (\id -> hostBuilder apiKey resource id)

exampleBuilder = getRequestURL "http://example.com" "1337hAsk3ll" "books"

flipBinaryArgs binaryFunction = (\x y -> binaryFunction y x)

subtract2 x = flip (-) 2

-- Q 5.1
inc n = n + 1
double n = n * 2
square n = n ^ 2

ifEvenInc = ifEven inc
ifEvenDouble = ifEven double
ifEvenSquare = ifEven square


-- Q 5.2
binaryPartialApplication binaryFunction x =
    (\y -> flipBinaryArgs binaryFunction x)
