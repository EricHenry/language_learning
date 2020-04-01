messyMain :: IO ()
messyMain = do
    print "Who is the email for?"
    recipient <- getLine
    print "What is the Title?"
    title <- getLine
    print "Who is the Author?"
    author <- getLine
    print
        (  "Dear "
        ++ recipient
        ++ ",\n"
        ++ "Thanks for buying "
        ++ title
        ++ "\nthanks, \n"
        ++ author
        )

toPart recipient = "Dear " ++ recipient ++ ", you smell awful.\n"

bodyPart bookTitle =
    "Thanks for buying " ++ bookTitle ++ ", but I don't really care.\n"

fromPart author =
    "Do something worth while with your life.\nThanks,\n" ++ author

createRudeEmail recipient bookTitle author =
    toPart recipient ++ bodyPart bookTitle ++ fromPart author

main :: IO ()
main = do
    print "Who is the email for?"
    recipient <- getLine
    print "What is the Title?"
    title <- getLine
    print "Who is the Author?"
    author <- getLine
    print (createRudeEmail recipient title author)
