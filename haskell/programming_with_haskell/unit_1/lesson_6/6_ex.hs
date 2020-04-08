
teams = ["red", "yellow", "orange", "blue", "purple"]

-- cons (:) creating a list from a value and a list
t = 1 : []

-- generate a list from 1 through 10
oneToTen = [1 .. 10]

-- generate odd numbers from 1 through 10
oddNumbers = [1, 3 .. 10]

-- genarate a list in increments of 0.5
halves = [1, 1.5 .. 5]

-- generate a decrementing list from 1 through -10
dec = [1, 0 .. -10]

-- an unending list from 1 through infinity
inf = [1 ..]

-- Binary operator is an operator that takes 2 inputs. i.e 1 + 2 with + being the binary operator.
-- partial application of a binary infix operator is called a section
paExample1 = (!!) "dog"
-- paExample1 2 = 'g'

paExample2 = ("dog" !!)
-- paExample2 2 = 'g'

paExample3 = (!! 2)
-- paExample3 "dog" = 'g'

-- parens are not optional. for creating sections above.

assignToGroups n aList = zip groups aList where groups = cycle [1 .. n]

teamGroups = assignToGroups 2 teams


-- Q 6.1
-- write a function repeat that takes a value and repeats it infinitely
myRepeat n = cycle [n]

-- Q 6.2
-- write a function subseq that takes three arguments
-- a start position
-- an end position and a list
-- returns the subsequence between the start and end
-- ex subseq 2 5 [1 .. 10] == [3, 4, 5]
subseq start end aList = take subseqLength beginningSeq
  where
    beginningSeq = drop start aList
    subseqLength = end - start


-- Q 6.3
-- inFirstHalf returns True if an Element is in the first half of a list,
-- otherwise returns false
inFirstHalf val aList = val `elem` firstHalf
  where
    listLength = length aList
    halfLength = listLength `div` 2
    firstHalf  = take halfLength aList

