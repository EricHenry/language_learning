-- Recursion and Pattern Matching --
-- reading is a recursive process

-- writing a recursive function
-- 1. Identify the end goal(s).                                   
-- 2. Determine what happens when a goal is reached
-- 3. List all alternate possibilities
-- 4. Determine your "rinse and repeat" process.
-- 5. Ensure that each alternative moves you toward your goal.


myGCD a b = if remainder == 0 then b else myGCD b remainder
    where remainder = a `mod` b


-- pattern matching
sayAmount 1 = "one"
sayAmount 2 = "two"
sayAmount n = "a bunch"


isEmpty [] = True
isEmpty _  = False

myHead (x : xs) = x
myHead []       = error "No head for empty list"


-- Q 7.1
myTail (_ : xs) = xs
myTail []       = []

-- Q 7.2
myGCD2 a 0 = a
myGCD2 a b = myGCD2 b (a `mod` b)
