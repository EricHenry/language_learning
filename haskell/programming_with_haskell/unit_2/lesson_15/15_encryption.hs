----------------------------------------------
-- Rotation Encryption fun in Haskell!
----------------------------------------------
data FourLetterAlphabet = L1 | L2 | L3 | L4
  deriving (Show, Enum, Bounded)

rotN :: (Bounded a, Enum a) => Int -> a -> a
rotN alphabetSize c = toEnum rotation
  where
    halfAlphabet = alphabetSize `div` 2
    offset       = fromEnum c + halfAlphabet
    rotation     = offset `mod` alphabetSize

largestCharNumber :: Int
largestCharNumber = fromEnum (maxBound :: Char)

rotChar :: Char -> Char
rotChar charToEncrypt = rotN sizeOfAlphabet charToEncrypt
    where sizeOfAlphabet = 1 + fromEnum (maxBound :: Char)


message :: [FourLetterAlphabet]
message = [L1, L3, L4, L1, L1, L2]

fourLetterAlphabetEncoder :: [FourLetterAlphabet] -> [FourLetterAlphabet]
fourLetterAlphabetEncoder vals = map rot4l vals
  where
    alphaSize = 1 + fromEnum (maxBound :: FourLetterAlphabet)
    rot4l     = rotN alphaSize


data ThreeLetterAlphabet = Alpha | Beta | Kappa
    deriving (Show,Enum,Bounded)

threeLetterMessage :: [ThreeLetterAlphabet]
threeLetterMessage = [Alpha, Alpha, Beta, Alpha, Kappa]

threeLetterEncoder :: [ThreeLetterAlphabet] -> [ThreeLetterAlphabet]
threeLetterEncoder vals = map rot3l vals
  where
    alphaSize = 1 + fromEnum (maxBound :: ThreeLetterAlphabet)
    rot3l     = rotN alphaSize

rotNdecoder :: (Bounded a, Enum a) => Int -> a -> a
rotNdecoder n c = toEnum rotation
  where
    halfN    = n `div` 2
    offset   = if even n then fromEnum c + halfN else 1 + fromEnum c + halfN
    rotation = offset `mod` n

threeLetterDecoder :: [ThreeLetterAlphabet] -> [ThreeLetterAlphabet]
threeLetterDecoder vals = map rot3ldecoder vals
  where
    alphaSize    = 1 + fromEnum (maxBound :: ThreeLetterAlphabet)
    rot3ldecoder = rotNdecoder alphaSize

rotEncoder :: String -> String
rotEncoder text = map rotChar text
  where
    alphaSize = 1 + fromEnum (maxBound :: Char)
    rotChar   = rotN alphaSize

rotDecoder :: String -> String
rotDecoder text = map rotCharDecoder text
  where
    alphaSize      = 1 + fromEnum (maxBound :: Char)
    rotCharDecoder = rotNdecoder alphaSize

----------------------------------------------
-- XOR Encryption fun in Haskell!
----------------------------------------------

xorBool :: Bool -> Bool -> Bool
xorBool value1 value2 = (value1 || value2) && (not (value1 && value2))

xorPair :: (Bool, Bool) -> Bool
xorPair (v1, v2) = xorBool v1 v2

xor :: [Bool] -> [Bool] -> [Bool]
xor list1 list2 = map xorPair (zip list1 list2)

-- our own representation of bit
type Bits = [Bool]

intToBits' :: Int -> Bits
intToBits' 0 = [False]
intToBits' 1 = [True]
intToBits' n = if (remainder == 0)
    then False : intToBits' nextVal
    else True : intToBits' nextVal
  where
    remainder = n `mod` 2
    nextVal   = n `div` 2

maxBits :: Int
maxBits = length (intToBits' maxBound)

intToBits :: Int -> Bits
intToBits n = leadingFalses ++ reversedBits
  where
    reversedBits  = reverse (intToBits' n)
    missingBits   = maxBits - (length reversedBits)
    leadingFalses = take missingBits (cycle [False])

charToBits :: Char -> Bits
charToBits char = intToBits (fromEnum char)

-- converting bits to an Int is equal to
-- the sum of b*2^i
-- where i is the index of the bit location
-- and b is 1 for on and 0 for off
-- bits 101 == 1*2^2 + 0*2^1 + 1*2^0 == 5
bitsToInt :: Bits -> Int
bitsToInt bits = sum (map (\x -> 2 ^ (snd x)) trueLocations)
  where
    size          = length bits
    indicies      = [size - 1, size - 2 .. 0]
    trueLocations = filter (\x -> fst x == True) (zip bits indicies)

bitsToChar :: Bits -> Char
bitsToChar bits = toEnum (bitsToInt bits)

myPad :: String
myPad = "Shhhhhh"

myPlainText :: String
myPlainText = "Haskell"

applyOTP' :: String -> String -> [Bits]
applyOTP' pad plaintext = map (\pair -> (fst pair) `xor` (snd pair))
                              (zip padBits plaintextBits)
  where
    padBits       = map charToBits pad
    plaintextBits = map charToBits plaintext

applyOTP :: String -> String -> String
applyOTP pad plaintext = map bitsToChar bitList
    where bitList = applyOTP' pad plaintext

encoderDecoder :: String -> String
encoderDecoder = applyOTP myPad

----------------------------------------------
-- Creating a Cipher TypeClass
----------------------------------------------

class Cipher a where
    encode :: a -> String -> String
    decode :: a -> String -> String

data Rot = Rot

instance Cipher Rot where
    encode Rot text = rotEncoder text
    decode Rot text = rotDecoder text

data OneTimePad = OTP String

instance Cipher OneTimePad where
    encode (OTP pad) text = applyOTP pad text
    decode (OTP pad) text = applyOTP pad text

myOTP :: OneTimePad
myOTP = OTP (cycle [minBound .. maxBound])


----------------------------------------------
-- Extending the exercise 
--
-- use the PRNG to create a StreamCipher type 
-- that can be an instance of the Cipher class
--
-- PRNG -> Pseudo Random Number Generator
----------------------------------------------

-- a and b parameters are initialization parameters that
-- help determine the randomness, 
-- maxNumber determines the upper bound of the number that
-- can be produced
prng :: Int -> Int -> Int -> Int -> Int
prng a b maxNumber seed = (a * seed + b) `mod` maxNumber

examplePRNG :: Int -> Int
examplePRNG = prng 1337 7 100

-- generate a PRNG int whos upper bound is the size
-- of all possible Characters
charPRNG :: Int -> Int
charPRNG = prng 1337 7 charsSize
    where charsSize = 1 + fromEnum (maxBound :: Char)

-- creates an infinite list of PRNGs
generatePadSeeds :: Int -> [Int]
generatePadSeeds seed = nextSeed : generatePadSeeds nextSeed
    where nextSeed = charPRNG seed

applySC' :: [Int] -> String -> [Bits]
applySC' seeds plaintext = map (\(padBit, ptBit) -> padBit `xor` ptBit)
                               (zip padBits plaintextBits)
  where
    padBits       = map intToBits seeds
    plaintextBits = map charToBits plaintext

applySC :: Int -> String -> String
applySC seed plaintext = map bitsToChar bitList
    where bitList = applySC' (generatePadSeeds seed) plaintext

type Seed = Int
data StreamCipher = SC Seed

instance Cipher StreamCipher where
    encode (SC seed) text = applySC seed text
    decode (SC seed) text = applySC seed text

