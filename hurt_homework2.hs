module Homework2 where
import Test.QuickCheck
-- Function prob1
-- @type
-- @param
-- @output
-- @description:
-- listComp f p xs = [ f x | x <- xs, p x]
-- [f x | x <- xs] is equivalent to map f xs
-- This function first filters an input and applies a map to it. By using map, we can apply the function to everything that passes the filter, p. 
prob1 :: (a->a) -> (a->Bool) -> [a] -> [a] 
prob1 f p xs = map f (filter p xs)
	
-- Function prob2
-- @type
-- @param
-- @output
-- @description: For prob2 we used recursion to solve. For the first case, negative numbers, we just simply assign a empty array. Next, we assign x<10 as a base case, when it triggers just to return a list with x. This is the base case because we're constantly dividing by 10 to break out each number and that isn't needed when there's one number. The last case is when the number is positive and bigger than 10. For this we recursevely send the function the number/10 and add the remainder to the list after the recursion

prob2 :: Integer -> [Integer]
prob2 x
  | x < 0 = []
  | x < 10 = [x]
  | x >= 10 = prob2 (div x 10) ++ [mod x 10]

--prob3 :: a
--prob3 = undefined
--Function prob3
-- @type
-- @param
-- @output
-- @description: For prob3, our thought process was much like prob 2; which was to divide by 10 each time till it was below 10 and then to add the last number. The difference on this was that we needed to add numbers to the list BEFORE calling the recursion. This will put the list in reverse order.
prob3 :: Integer -> [Integer]
prob3 x
  | x < 0 = []
  | x >= 10 = [mod x 10] ++ prob3 (div x 10)
  | x >= 0 = x : []
-- Function prob4
-- @type
-- @param
-- @output
-- @description: Checks the length of the list to find out if it should multiply the first integer, then performs appropriate calculation and recursively calls the rest of the list
--If even, multiplies the head of the list. If odd it is left alone. This results in every other integer doubled, with the last integer the start that is never doubled
prob4 :: [Integer] -> [Integer]
prob4 [] = []
prob4 [x] = [x]
prob4 (x:xs) 
  | (length (x:xs)) `mod` 2 == 0 = (x * 2) : (prob4 xs)
  | otherwise = x : (prob4 xs)


-- Function prob5
-- @type
-- @param
-- @output
-- @description: Recursive; breaks up each number in a given list into individual digits and adds them up, recursively, therefore allowing it to work on number of any size
prob5 :: [Integer] -> Integer
prob5 [] = 0
prob5 [x] 
  | x > 9 = (x `mod` 10) + (prob5 [(x `div` 10)])
  | otherwise = x 
prob5 (x:xs) 
  | x > 9 = (x `mod` 10) + (prob5 [(x `div` 10)]) + prob5 (xs)
  | otherwise = x + (prob5 xs)  



---------------------------------------------
--               Unit Tests                --
---------------------------------------------
test_prob1 :: IO ()
test_prob1  = do
  putStrLn "Problem 1 Results:"
  prob1_test1
  prob1_test2
test_prob2 :: IO ()
test_prob2  = do
  putStrLn "Problem 2 Results:"
  prob2_test1
  prob2_test2
test_prob3 :: IO ()
test_prob3  = do
  putStrLn "Problem 3 Results:"
  prob3_test1
test_prob4 :: IO ()
test_prob4  = do
  putStrLn "Problem 4 Results:"
  prob4_test1
  prob4_test2
test_prob5 :: IO ()
test_prob5  = do
  putStrLn "Problem 5 Results:"
  prob5_test1
test_probs :: IO ()
test_probs  = do
  putStrLn "-------- All Problem Results --------"
  test_prob1
  test_prob2
  test_prob3
  test_prob4
  test_prob5
  putStrLn "-------------------------------------"
prob1_test1 = quickCheckWith (stdArgs {maxSuccess = 1000}) prob1_property1
  where
    prob1_property1 :: [Integer] -> Bool
    prob1_property1 xs = lComp (+1) (even) xs == prob1 (+1) (even) xs
      where lComp f p xs = [ f x | x <- xs, p x]
prob1_test2 = quickCheckWith (stdArgs {maxSuccess = 1000}) prob1_property2
  where
    prob1_property2 :: [Int] -> Bool
    prob1_property2 xs = lComp (*2) (odd) xs == prob1 (*2) (odd) xs
      where lComp f p xs = [ f x | x <- xs, p x]
prob2_test1 = quickCheckWith (stdArgs {maxSuccess = 1000}) prob2_property1
  where
    prob2_property1 :: Integer -> Bool
    prob2_property1 xs = abs xs == (go1 . prob2) (abs xs)
      where go1 :: [Integer] -> Integer
            go1 xs
              | (null xs) = 0
              | otherwise = let pos = filter (> -1) xs
                            in  read (foldl (++) "" $ map show pos) :: Integer
prob2_test2 = quickCheckWith (stdArgs {maxSuccess = 1000}) prob2_property2
  where
    prob2_property2 :: Integer -> Bool
    prob2_property2 xs  = prob2 xs == prob2_dual xs
      where prob2_dual :: Integer -> [Integer]
            prob2_dual x
              | x < 0      = []
              | otherwise  = map go' $ show x
              where go' '0' = 0
                    go' '1' = 1
                    go' '2' = 2
                    go' '3' = 3
                    go' '4' = 4
                    go' '5' = 5
                    go' '6' = 6
                    go' '7' = 7
                    go' '8' = 8
                    go' '9' = 9
prob3_test1 = quickCheckWith (stdArgs {maxSuccess = 1000}) prob3_property1
  where
    prob3_property1 :: Integer -> Bool
    prob3_property1 xs  = prob3 xs == go1 xs
      where go1 :: Integer -> [Integer]
            go1 n | n < 0      = []
                  | otherwise  = reverse $ map go' $ show n
              where go' '0' = 0
                    go' '1' = 1
                    go' '2' = 2
                    go' '3' = 3
                    go' '4' = 4
                    go' '5' = 5
                    go' '6' = 6
                    go' '7' = 7
                    go' '8' = 8
                    go' '9' = 9
prob4_test1 = quickCheckWith (stdArgs {maxSuccess = 1000}) prob4_property1
  where
    prob4_property1 :: Integer -> Integer -> Integer -> Integer -> Bool
    prob4_property1 w x y z = [(w + w),x, (y + y), z] == prob4 [w,x,y,z]
prob4_test2 = quickCheckWith (stdArgs {maxSuccess = 1000}) prob4_property2
  where
    prob4_property2 :: Integer -> Integer -> Integer -> Integer -> Integer -> Bool
    prob4_property2 v w x y z = [v, (w + w), x, (y + y), z] == prob4 [v,w,x,y,z]
prob5_test1 = quickCheckWith (stdArgs {maxSuccess = 1000}) prob5_property
  where
    prob5_property :: [Integer] -> Bool
    prob5_property xs = prob5 (map (abs) xs) == go' xs
    go' :: [Integer] -> Integer
    go' is = go1 (map (abs) is) 0
      where go1 :: [Integer] -> Integer -> Integer
            go1 [] n     = n
            go1 (x:xs) n | (x < 10)   = go1 xs (x + n)
                         | (x > 9)    = go1 xs ((sum (go2 x)) + n)
                         | otherwise  = go1 xs n
            go2 :: Integer -> [Integer]
            go2 x
              | x < 0      = []
              | otherwise  = map go3 $ show x
            go3 :: Char -> Integer
            go3 '0' = 0
            go3 '1' = 1
            go3 '2' = 2
            go3 '3' = 3
            go3 '4' = 4
            go3 '5' = 5
            go3 '6' = 6
            go3 '7' = 7
            go3 '8' = 8
            go3 '9' = 9
