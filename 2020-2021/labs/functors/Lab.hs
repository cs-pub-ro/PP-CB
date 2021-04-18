sumExtremities :: [Int] -> Maybe Int
sumExtremities [] = Nothing
sumExtremities l = Just $ head l + last l


data Tree a = Nil | Node a [Tree a] deriving Show
data BTree a = BNil | BNode a (BTree a) (BTree a) deriving Show

t = Node 1 [Node 2 [], Node 3 [Node 4 [Node 5 []]]]

instance Functor Tree where
    fmap _ Nil = Nil
    fmap f (Node x cs) = Node (f x) (fmap (fmap f) cs)

{-
data Set a = Set (a -> Bool)

instance Functor Set where
    fmap f (Set g) = Set (g . f)
-}

{-
instance Functor ((,) a) where
    fmap f (a, b) = (a, f b)

instance Functor ((->) a) where
    fmap f g = \x -> f (g x)   -- fmap = (.)
-}

instance Foldable Tree where
    foldr _ z Nil = z
    foldr f z (Node e cs) = f e (foldr (\c z -> foldr f z c) z cs)


class Zippable z where
    zipp :: (a -> b -> c) -> z a -> z b -> z c


instance Zippable [] where
    zipp _ [] _ = []
    zipp _ _ [] = []
    zipp f (x:xs) (y:ys) = f x y : zipp f xs ys

instance Zippable BTree where
    zipp _ BNil _ = BNil
    zipp _ _ BNil = BNil
    zipp f (BNode e l r) (BNode e' l' r') = BNode (f e e') (zipp f l l') (zipp f r r')

instance Zippable Maybe where
    zipp _ Nothing _ = Nothing
    zipp _ _ Nothing = Nothing
    zipp f (Just x) (Just y) = Just (f x y)

instance Zippable (Either a) where
    zipp _ (Left x) _ = Left x
    zipp _ _ (Left x) = Left x
    zipp f (Right x) (Right y) = Right (f x y)

instance Zippable Tree where
    zipp _ Nil _ = Nil
    zipp _ _ Nil = Nil
    zipp f (Node x cxs) (Node y cys) = Node (f x y) (zipp (zipp f) cxs cys)
    --
instance Zippable ((->) a) where
    zipp f g h = \x -> f (g x) (h x)
