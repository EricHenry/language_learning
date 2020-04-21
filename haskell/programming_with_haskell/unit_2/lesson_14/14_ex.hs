class Describable a where
    describe :: a -> String

data NewEngland = ME | VT | NH | MA | RI | CT

data SixSidedDie = S1 | S2 | S3 | S4 | S5 | S6
    deriving (Eq,Ord,Enum)

instance Show SixSidedDie where
    show S1 = "I" -- "one"
    show S2 = "II" -- "two"
    show S3 = "III" -- "three"
    show S4 = "IV" -- "four"
    show S5 = "V" -- "five"
    show S6 = "VI" -- "six"

data Name = Name (String, String)
    deriving (Show, Eq)

instance Ord Name where
    compare (Name (f1, l1)) (Name (f2, l2)) = compare (l1, f1) (l2, f2)

names :: [Name]
names =
    [ Name ("Emil", "Cioran")
    , Name ("Eugene", "Thacker")
    , Name ("Friedrich", "Nietzensche")
    ]

-- instance Enum SixSidedDie where
--     toEnum 0 = S1
--     toEnum 1 = S2
--     toEnum 2 = S3
--     toEnum 3 = S4
--     toEnum 4 = S5
--     toEnum 5 = S6
--     toEnum _ = error "No such value"

--     fromEnum S1 = 0
--     fromEnum S2 = 1
--     fromEnum S3 = 2
--     fromEnum S4 = 3
--     fromEnum S5 = 4
--     fromEnum S6 = 5

-- instance Eq SixSidedDie where
--     (==) S6 S6 = True
--     (==) S5 S5 = True
--     (==) S4 S4 = True
--     (==) S3 S3 = True
--     (==) S2 S2 = True
--     (==) S1 S1 = True
--     (==) _  _  = False

-- instance Ord SixSidedDie where
--     compare S6 S6 = Eq
--     compare S6 _  = GT
--     compare _  S6 = LT
--     compare S5 S5 = Eq
--     compare S5 _  = GT
--     compare _  S5 = LT
--     compare S4 S4 = Eq
--     compare S4 _  = GT
--     compare _  S4 = LT


-- Q 14.1
-- Use the derived implementation of enum to amke
-- manually defining Eq and ord much easer

data Number = One | Two | Three
    deriving (Enum)

instance Eq Number where
    (==) n1 n2 = ([fromEnum n1) == (fromEnum n2)

instance Ord Number where
    compare n1 n2 = compare (fromEnum n1) (fromEnum n2)


-- Q 14.2
-- define a five-sided die (FiveSidedDie type). then Define
-- a type class named Die and at laest one method that
-- would be useful to have for a die. Also include
-- superclasses you think make sense for a die. Finally,
-- make your FiveSidedDie an instance of Die

data FiveSidedDie = Side1 | Side2 | Side3 | Side4 | Side5
    deriving (Show, Eq, Enum)

class (Eq a, Enum a) => Die a where
    roll :: Int -> a

instance Die FiveSidedDie where
    roll n = toEnum (n 'mod' 5)