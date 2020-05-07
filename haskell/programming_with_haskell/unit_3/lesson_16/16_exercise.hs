--
-- Unit 3 Lesson 16 Exercises
--
--data AuthorName = AuthorName String String
--data Book = Author String String Int
--data AuthorName = AuthorName { firstName :: String , lastName  :: String }

type FirstName = String
type LastName = String
type MiddleName = String

data Name = Name FirstName LastName
          | NameWithMiddle FirstName MiddleName LastName
          | TwoInitialsWithLast Char Char LastName
          | FirstNameWithTwoInits FirstName Char Char

data Author = Author Name

data Artist = Person Name
            | Band String

data Creator =  AuthorCreator Author | ArtistCreator Artist

hpLovecraft :: Creator
hpLovecraft = AuthorCreator (Author (TwoInitialsWithLast 'H' 'P' "Lovecraft"))

andrewWK :: Creator
andrewWK = AuthorCreator (Author (FirstNameWithTwoInits "Andrew" 'W' 'K'))

data Book = Book { author     :: Creator
                 , isbn       :: String
                 , bookTitle  :: String
                 , bookYear   :: Int
                 , bookPrice  :: Double
                 }

data VinylRecord = VinylRecord { artist      :: Creator
                               , recordTitle :: String
                               , recordYear  :: Int
                               , recordPrice :: Double
                               }

data CollectibleToy = CollectibleToy { name        :: String
                                     , description :: String
                                     , toyPrice    :: Double
                                     }

data StoreItem = BookItem Book
               | RecordItem VinylRecord
               | ToyItem CollectibleToy
               | PamphletItem Pamphlet

price :: StoreItem -> Double
price (BookItem     book  ) = bookPrice book
price (RecordItem   record) = recordPrice record
price (ToyItem      toy   ) = toyPrice toy
price (PamphletItem _     ) = 0.0

--madeBy :: StoreItem -> String
--madeBy (BookItem   book  ) = show (author book)
--madeBy (RecordItem record) = show (artist record)
--madeBy _                   = "unknown"

----------------------------------------------
-- Exercises
----------------------------------------------

----------------------------------------------
-- Exercises 16.1
--
-- Create a Pamphlet type (that is free) that
-- has a title, description and contact field
-- for the organization that provides the 
-- pamphlet
----------------------------------------------

data Pamphlet = Pamphlet { pamphletTitle :: String
                         , pamphletDesc  :: String
                         , contact       :: String
                         }


----------------------------------------------
-- Exercises 16.2
--
-- create a Shape type that includes the 
-- following shapes Circle, Square, and Rectangle. 
-- Then write a function to compute the perimeter 
-- of a shape as well as its area
----------------------------------------------

type Radius = Double
type Height = Double
type Width = Double

data Shape = Circle Radius
           | Square Length
           | Rectangle Height Width
           deriving Show

perimeter :: Shape -> Double
perimeter (Circle r     ) = 2 * pi * r
perimeter (Square h     ) = 4 * h
perimeter (Rectangle h w) = 2 * (w + h)

area :: Shape -> Double
area (Circle r     ) = (pi * r) ^ 2
area (Square h     ) = h ^ 2
area (Rectangle h w) = w * h
