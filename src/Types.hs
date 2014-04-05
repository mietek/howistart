{-# LANGUAGE OverloadedStrings #-}

module Types
  (
    CategoryAtom(..)
    ,Category(..)
    ,Categories
    ,Post(..)
    ,Posts
    ,lookupPostsByCategory
    ,lookupCategoryByName
    ,categoryName
    ,splicesFromPost
  ) where

------------------------------------------------------------------------------
import Heist
import Data.List as L
import Data.Text.Encoding
import qualified Data.Text as T
import qualified Data.ByteString as B
import qualified Heist.Interpreted as I

data CategoryAtom = Haskell
                  | Erlang
                  | Elixir
                  deriving (Show, Read, Eq)

data Category = Category T.Text T.Text T.Text
              deriving (Show, Read)

type Categories = [(CategoryAtom, Category)]

data Post = Post {
  key           :: Integer
  , title      :: T.Text
  , author     :: T.Text
  , category   :: CategoryAtom
  , subheading :: T.Text
  , bio        :: T.Text
  } deriving (Show, Read)

type Posts = [Post]

lookupPostsByCategory :: CategoryAtom -> Posts -> Posts
lookupPostsByCategory c ps =
  Prelude.filter (\p -> (category p) == c) ps

lookupCategoryByName :: Maybe B.ByteString -> Categories -> Maybe (CategoryAtom, Category)
lookupCategoryByName Nothing _ = Nothing
lookupCategoryByName (Just n) cs =
  let
    lowerName = T.toLower (decodeUtf8 n)
  in
   L.find (\(_, Category name _ _) -> (T.toLower name) == lowerName) cs

categoryName :: CategoryAtom -> [(CategoryAtom, Category)] -> T.Text
categoryName a c =
  let Just (Category n _ _) = lookup a c in n

splicesFromPost :: Monad n => Categories -> Post -> Splices (I.Splice n)
splicesFromPost c p = do
  "key"        ## I.textSplice (T.pack $ show (key p))
  "title"      ## I.textSplice (title p)
  "author"     ## I.textSplice (author p)
  "category"   ## I.textSplice (categoryName (category p) c)
  "subheading" ## I.textSplice (subheading p)
  "bio"        ## I.textSplice (bio p)
