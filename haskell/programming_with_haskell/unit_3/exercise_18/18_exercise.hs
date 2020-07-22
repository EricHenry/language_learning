import qualified Data.Map                      as Map

-- Parameterized type
data Box a = Box a
    deriving Show

wrap :: a -> Box a
wrap x = Box x

unwrap :: Box a -> a
unwrap (Box x) = x


data Triple a = Triple a a a
    deriving Show


type Point3D = Triple Double

aPoint :: Point3D
aPoint = Triple 0.1 53.2 12.3


type FullName = Triple String

aPerson :: FullName
aPerson = Triple "Howard" "Phillips" "Lovecraft"


type Initials = Triple Char

initials :: Initials
initials = Triple 'H' 'P' 'L'


first :: Triple a -> a
first (Triple x _ _) = x

second :: Triple a -> a
second (Triple _ x _) = x

third :: Triple a -> a
third (Triple _ _ x) = x

toList :: Triple a -> [a]
toList (Triple x y z) = [x, y, z]

transform :: (a -> a) -> Triple a -> Triple a
transform f (Triple x y z) = Triple (f x) (f y) (f z)

data List a = Empty | Cons a (List a)
    deriving Show

builtInEx1 :: [Int]
builtInEx1 = 1 : 2 : 3 : []

ourListEx1 :: List Int
ourListEx1 = Cons 1 (Cons 2 (Cons 3 Empty))

builtInEx2 :: [Char]
builtInEx2 = 'c' : 'a' : 't' : []

ourListEx2 :: List Char
ourListEx2 = Cons 'c' (Cons 'a' (Cons 't' Empty))

ourMap :: (a -> b) -> List a -> List b
ourMap _    Empty         = Empty
ourMap func (Cons a rest) = Cons (func a) (ourMap func rest)

itemCount1 :: (String, Int)
itemCount1 = ("Erasers", 25)

itemCount2 :: (String, Int)
itemCount2 = ("Pencils", 25)

itemCount3 :: (String, Int)
itemCount3 = ("Pens", 13)

itemInventory :: [(String, Int)]
itemInventory = [itemCount1, itemCount2, itemCount3]
