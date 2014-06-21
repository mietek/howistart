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
    ,splicesFromPost
  ) where

------------------------------------------------------------------------------
import Heist

import Data.Maybe
import Data.List as L
import Data.Text.Encoding
import qualified Data.Text as T
import qualified Data.ByteString as B
import qualified Heist.Interpreted as I
import Text.XmlHtml

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
  } deriving (Show, Read)

type Posts = [Post]

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

categoryName :: CategoryAtom -> [(CategoryAtom, Category)] -> T.Text
categoryName a c =
  let Just (Category n _ _) = lookup a c in n

splicesFromPost :: Monad n => Categories -> Post -> Splices (I.Splice n)
splicesFromPost c p = do
  "key"        ## I.textSplice (T.pack $ show (_key p))
  "title"      ## I.textSplice (_title p)
  "author"     ## I.textSplice (_author p)
  "category"   ## I.textSplice (categoryName (_category p) c)
  "subheading" ## I.textSplice (_subheading p)
  "bio"        ## bio p

bio :: Monad n => Post -> I.Splice n
bio p = do
  case parseHTML "bio" (encodeUtf8 $ _bio p) of
    (Right doc) ->
      return $ docContent doc
    (Left e) ->
      I.textSplice (T.pack e)
