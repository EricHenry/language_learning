
myDrop _ []       = []
myDrop 0 rest     = rest
myDrop n (_ : xs) = myDrop (n - 1) xs

myTake _ []       = []
myTake 0 end      = end
myTake n (x : xs) = x : rest where rest = myTake (n - 1) xs

myLength []       = 0
myLength (_ : xs) = 1 + myLength xs

-- take the first elem, add it to calling myCycle with the rest of the list with the first element at the end
myCycle (first : rest) = first : myCycle (rest ++ [first])
-- myCycle [1, 2, 3]
--    [1] : myCycle [2, 3, 1]
--    [1] : [2] : myCycle [3, 1, 2]
--    [1] : [2] : [3] : myCycle [1, 2, 3]
--    [1] : [2] : [3] : [1] : myCycle [2, 3, 1]
--    ...


ackermann 0 n = n + 1
ackermann m 0 = ackermann (m - 1) 1
ackermann m n = ackermann (m - 1) (ackermann m (n - 1))


collatz 1 = 1
collatz n = if even n then 1 + collatz (n `div` 2) else 1 + collatz (n * 3 + 1)

-- Q 8.1
myReverse []       = []
myReverse (x : xs) = (myReverse xs) ++ [x]

-- myReverse [1,2]
--  myReverse [2] ++ [1]
--   myReverse [] ++ [2] ++ [1]


-- Q 8.1
fib 0 = 0
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)


fastFib n1 n2 1       = n1 + 0
fastFib n1 n2 counter = fastFib n2 (n1 + n2) (counter - 1)

fastFib2 _ _ 0 = 0
fastFib2 _ _ 1 = 1
fastFib2 _ _ 2 = 1
fastFib2 x y 3 = x + y
fastFib2 x y c = fastFib2 (x + y) x (c - 1)

fib2 n = 1 1 n
