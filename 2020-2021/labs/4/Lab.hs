import Prelude hiding (Ordering, LT, EQ, GT, compare)



data Ordering = LT | EQ | GT deriving (Eq, Show)

compare :: Int -> Int -> Ordering
compare x y
    | x < y = LT
    | x == y = EQ
    | x > y = GT


insert :: Int -> [Int] -> [Int]
insert x [] = [x]
insert x (y:ys)
    | x < y = x : y : ys
    | otherwise = y : insert x ys

sort :: [Int] -> [Int]
sort = foldr insert []

insertBy :: (Int -> Int -> Ordering) -> Int -> [Int] -> [Int]
insertBy c x [] = [x]
insertBy c x (y:ys)
    | c x y == LT = x : y : ys
    | otherwise = y : insertBy c x ys

sortBy :: (Int -> Int -> Ordering) -> [Int] -> [Int]
sortBy c = foldr (insertBy c) []



data Point = Point Float Float deriving (Show, Eq)


distance :: Point -> Point -> Float
distance (Point x1 y1) (Point x2 y2) = sqrt ( (x2 - x1) ^ 2 + (y2 - y1) ^ 2)

-- It's actually wrong, discuss floating point operations + tolerance
collinear :: Point -> Point -> Point -> Bool
collinear (Point x1 y1) (Point x2 y2) (Point x3 y3) = 0.5 * (x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)) == 0


data Natural = Zero | Succ Natural


add :: Natural -> Natural -> Natural
add Zero y = y
add (Succ x) y = Succ (add x y)


mul :: Natural -> Natural -> Natural
mul Zero y = Zero
mul (Succ x) y = add (mul x y) y


data List a = Void | Cons a (List a)


length' Void = 0
length' (Cons x xs) = 1 + length' xs

toHaskell :: List a -> [a]
toHaskell Void = []
toHaskell (Cons x xs) = x : toHaskell xs


data BTree a = Nil | Node a (BTree a) (BTree a)

height Nil = 0
height (Node e l r) = 1 + max (height l) (height r)


size Nil = 0
size (Node e l r) = 1 + size l + size r


treeMap :: (a -> b) -> BTree a -> BTree b
treeMap f Nil = Nil
treeMap f (Node e l r) = Node (f e) (treeMap f l) (treeMap f r)


mirror :: BTree a -> BTree a
mirror Nil = Nil
mirror (Node e l r) = Node e (mirror r) (mirror l)

flatten :: BTree a -> [a]
flatten Nil = []
flatten (Node e l r) = e : (flatten l ++ flatten r)





data Student = Student String String [Float]


avg :: Student -> Float
avg (Student _ _ l) = sum l / (fromIntegral . length) l


studComp s1 s2 = compare (avg s1) (avg s2)

highestAverage :: [Student] -> String
highestAverage = undefined


data AExpr = Const Int | Var String | Add AExpr AExpr | Mul AExpr AExpr deriving (Show, Eq)
data BExpr = Eq AExpr AExpr | Not BExpr | Gt AExpr AExpr deriving (Show, Eq)type Context = [(String, Int)]
search :: Context -> String -> Int
search ((k, v):ks) q
    | k == q = v
    | otherwise = search ks qevalA :: Context -> AExpr -> Int
evalA c (Const x) = x
evalA c (Var x) = search c x
evalA c (Add e1 e2) = evalA c e1 + evalA c e2
evalA c (Mul e1 e2) = evalA c e1 * evalA c e2evalB :: Context -> BExpr -> Bool
evalB c (Eq e1 e2) = evalA c e1 == evalA c e2
evalB c (Not e) = not $ evalB c e
evalB c (Gt e1 e2) = evalA c e1 > evalA c e2
