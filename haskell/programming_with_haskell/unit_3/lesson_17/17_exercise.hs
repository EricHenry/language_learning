import           Data.List
import           Data.Semigroup

-- Function Composition
myLast :: [a] -> a
myLast = head . reverse

myMin :: Ord a => [a] -> a
myMin = head . sort

myMax :: Ord a => [a] -> a
myMax = myLast . sort

myAll :: (a -> Bool) -> [a] -> Bool
myAll predicate = (foldr (&&) True) . (map predicate)

-- Quick Check 17.1
-- implement myAny by using function composition
myAny :: (a -> Bool) -> [a] -> Bool
myAny predicate = (foldr (||) False) . (map predicate)


-- Combining Like Types: Semigroups

--data Color = Red | Yellow | Blue | Green | Purple | Orange | Brown
    --deriving (Show,Eq)

-- instance Semigroup Color where
--     (<>) Red    Blue   = Purple
--     (<>) Blue   Red    = Purple
--     (<>) Yellow Blue   = Green
--     (<>) Blue   Yellow = Green
--     (<>) Yellow Red    = Orange
--     (<>) Red    Yellow = Orange
--     (<>) a      b      = if a == b then a else Brown

-- Reimplementing Semigroup for Color to support associativity
-- using Guards
--instance Semigroup Color where
    -- (<>) Red    Blue   = Purple
    -- (<>) Blue   Red    = Purple
    --(<>) Yellow Blue   = Green
    --(<>) Blue   Yellow = Green
    --(<>) Yellow Red    = Orange
    --(<>) Red    Yellow = Orange
    --(<>) a b | a == b    = a
            -- | all (`elem` [Red, Blue, Purple]) [a, b] = Purple
            -- | all (`elem` [Blue, Yellow, Green]) [a, b] = Green
            -- | all (`elem` [Red, Yellow, Orange]) [a, b] = Orange
            -- | otherwise = Brown


-- 17.3.3 Practical Monoids

createPTable :: Events -> Probs -> PTable
createPTable (Events es) (Probs ps) = PTable (Events es)
                                             (Probs normalizedProbs)
  where
    totalProbs      = sum ps
    normalizedProbs = map (\x -> x / totalProbs) ps

showPair :: String -> Double -> String
showPair event prob = mconcat [event, "|", show prob, "\n"]

cartCombine :: (a -> b -> c) -> [a] -> [b] -> [c]
cartCombine func l1 l2 = zipWith func newL1 cycledL2
  where
    nToAdd     = length l2
    repeatedL1 = map (take nToAdd . repeat) l1
    newL1      = mconcat repeatedL1
    cycledL2   = cycle l2

coin :: PTable
coin = createPTable (Events ["heads", "tails"]) (Probs [0.5, 0.5])

spinner :: PTable
spinner =
    createPTable (Events ["red", "blue", "green"]) (Probs [0.1, 0.2, 0.7])

-- Q17.1
-- Color doesn't contain an identity element. Modify the code
-- in this unit so that Color does have an identity element,
-- and then make color an instance of Monoid

data Color = Red | Yellow | Blue | Green | Purple | Orange | Brown | Clear
    deriving (Show,Eq)

instance Semigroup Color where
    (<>) Clear  c      = c
    (<>) c      Clear  = c
    (<>) Red    Blue   = Purple
    (<>) Blue   Red    = Purple
    (<>) Yellow Blue   = Green
    (<>) Blue   Yellow = Green
    (<>) Yellow Red    = Orange
    (<>) Red    Yellow = Orange
    (<>) a b | a == b    = a
             | all (`elem` [Red, Blue, Purple]) [a, b] = Purple
             | all (`elem` [Blue, Yellow, Green]) [a, b] = Green
             | all (`elem` [Red, Yellow, Orange]) [a, b] = Orange
             | otherwise = Brown

instance Monoid Color where
    mempty  = Clear
    mappend = (<>)

-- Q17.2
-- If your Events and Probs types were data types and not just synonyms,
-- you could make them instances of Semigroup and Monoid, where
-- combineEvents and combineProbs where the <> operator in each case.
-- Refactor these types and make instances of Semigroup and Monoid

-- Events
data Events = Events [String]

instance Semigroup Events where
    (<>) (Events e1) (Events e2) = Events combined
      where
        combiner x y = mconcat [x, "-", y]
        combined = cartCombine combiner e1 e2

instance Monoid Events where
    mempty  = Events []
    mappend = (<>)

-- Probs
data Probs = Probs [Double]

instance Semigroup Probs where
    (<>) (Probs p1) (Probs p2) = Probs combined
        where combined = cartCombine (*) p1 p2

instance Monoid Probs where
    mempty  = Probs []
    mappend = (<>)

-- PTable
data PTable = PTable Events Probs
instance Show PTable where
    show (PTable (Events events) (Probs probs)) = mconcat pairs
        where pairs = zipWith showPair events probs

instance Semigroup PTable where
    (<>) ptable1 (PTable (Events []) (Probs [])) = ptable1
    (<>) (PTable (Events []) (Probs [])) ptable2 = ptable2
    (<>) (PTable e1 p1) (PTable e2 p2) = createPTable newEvents newProbs
      where
        newEvents = e1 <> e2
        newProbs  = p1 <> p2

instance Monoid PTable where
    mempty  = PTable (Events []) (Probs [])
    mappend = (<>)

