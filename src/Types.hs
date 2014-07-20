{-# LANGUAGE OverloadedStrings #-}

module Types
  (
    CategoryAtom(..)
    ,Category(..)
    ,Categories
    ,Post(..)
    ,Posts
    ,postExists
    ,lookupPost
    ,lookupCategoryAtom
    ,lookupPostsByCategory
    ,lookupCategoryByName
    ,categoryName
  ) where

------------------------------------------------------------------------------
import Data.Maybe
import Data.List as L
import Data.Text.Encoding
import qualified Data.Text as T
import qualified Data.ByteString as B

data CategoryAtom = Haskell
                  | Erlang
                  | Elixir
                  | Go
                  | Rust
                  | Python
                  | Ruby
                  | Clojure
                  | Ocaml
                  deriving (Show, Read, Eq)

data Category = Category T.Text T.Text T.Text
              deriving (Show, Read)

type Categories = [(CategoryAtom, Category)]

data Post = Post {
  _key          :: Integer
  , _title      :: T.Text
  , _author     :: T.Text
  , _category   :: CategoryAtom
  , _subheading :: T.Text
  , _bio        :: T.Text
  , _published  :: T.Text
  } deriving (Show, Read)

type Posts = [Post]

--
-- Accessors and Lookup
--

postExists :: CategoryAtom -> Integer -> Posts -> Bool
postExists c k ps =
  isJust $ L.find (\p -> _key p == k && _category p == c) ps

lookupPost :: CategoryAtom -> Integer -> Posts -> Maybe Post
lookupPost c k ps =
  L.find (\p -> _key p == k && _category p == c) ps


lookupCategoryAtom :: B.ByteString -> Categories -> Maybe CategoryAtom
lookupCategoryAtom c cs =
  let
    lowerName = T.toLower (decodeUtf8 c)
  in
   case L.find (\(_, Category name _ _) -> name == lowerName) cs of
     Just (cAtom, _) -> Just cAtom
     Nothing -> Nothing

lookupPostsByCategory :: CategoryAtom -> Posts -> Posts
lookupPostsByCategory c ps =
  Prelude.filter (\p -> _category p == c) ps

lookupCategoryByName :: B.ByteString -> Categories -> Maybe (CategoryAtom, Category)
lookupCategoryByName n cs =
  let
    lowerName = T.toLower (decodeUtf8 n)
  in
   L.find (\(_, Category name _ _) -> name == lowerName) cs

categoryName :: [(CategoryAtom, Category)] -> CategoryAtom -> T.Text
categoryName c a =
  let Just (Category n _ _) = lookup a c in n
