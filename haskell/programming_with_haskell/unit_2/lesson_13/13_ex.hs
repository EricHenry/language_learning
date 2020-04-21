class Describable a where
    describe :: a -> String

data Icecream = Chocolate | Vanilla
    deriving (Show, Eq, Ord)

-- Q 13.1
-- How is Word type different from Int?
-- they share identical type clasess
-- they have different bounds
--
-- minBound :: Word == 0
-- maxBound :: Word == 18446744073709551615
--
-- minBound :: Int == -9223372036854775808
-- maxBound :: Int == 9223372036854775807
--
-- so Word is an Int that takes on only positive values
-- Word is essentially an unsigned Int


-- Q 13.2
-- look at the info for Enum
-- the succ function on an enum is
-- succ :: a -> a
--
-- inc:: Int -> Int
-- inc x = x + 1
--
-- What is the difference between succ and inc?
--
-- succ on the maxBound of an Int will throw an error because there is not
-- a true successor to the maxBound of a bounded type
-- However the inc function just rotates the value back to the beginning
-- i.e the minBound


-- Q 13.3
-- Write the following function that works just like succ on
-- Bounded types but can be called an unlimited number of
-- times without error. The function will work like inc in
-- the preceding example but works on a wider tange of 
-- types, including types that aren't memebers of Num
--
-- cycleSucc :: (Bounded a, Enum a, ? a) => a -> a
-- cycleSucc n = ?
--
-- your definition will include functions/values from
-- Bounded, Enum, and the mystery type class Make a note
-- of where each of these three (or more) functions/values
-- come from.

cycleSucc :: (Bounded a, Enum a, Eq a) => a -> a
cycleSucc n = if n == maxBound then minBound else succ n
