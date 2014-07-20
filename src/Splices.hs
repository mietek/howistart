{-# LANGUAGE OverloadedStrings #-}

module Splices
  ( allCategories
  , postHeader
  , allPostsForCategory
  , allPosts
  ) where

import Snap.Core
import Data.Text.Encoding
import Heist
import Control.Monad.Trans
import qualified Text.XmlHtml as X
import Data.ByteString.Char8
import qualified Data.Text as T
import qualified Heist.Compiled as C
import Blaze.ByteString.Builder.Internal.Types
import Types

--
-- Categories Header
--
allCategoriesRuntime :: MonadIO n => RuntimeSplice n [T.Text]
allCategoriesRuntime = do
  f <- liftIO $ Prelude.readFile "app.cfg"
  let (c, _) = read f :: (Categories, Posts)
      categoryNames = [name | (_, Category name _ _) <- c]
  return categoryNames

splicesFromCategory :: Monad n => Splices (RuntimeSplice n T.Text -> C.Splice n)
splicesFromCategory = mapS (C.pureSplice . C.textSplice) $ "category" ## id

renderCategories :: Monad n => RuntimeSplice n [T.Text] -> C.Splice n
renderCategories = C.manyWithSplices C.runChildren splicesFromCategory

allCategories :: MonadIO n => Splices (C.Splice n)
allCategories = "categories" ## renderCategories allCategoriesRuntime

--
-- Posts Splices
--
postsRuntime :: MonadSnap n => Categories -> Posts -> RuntimeSplice n Posts
postsRuntime cs ps = do
  (Just c) <- lift $ getParam "category"
  let Just (categoryAtom, Category{}) = lookupCategoryByName c cs
    in return $ lookupPostsByCategory categoryAtom ps

splicesFromPost :: Monad n => Categories -> Splices (RuntimeSplice n Post -> C.Splice n)
splicesFromPost c = mapS C.pureSplice $ do
  "key"        ## C.textSplice $ T.pack . show . _key
  "title"      ## C.textSplice $ _title
  "author"     ## C.textSplice $ _author
  "category"   ## C.textSplice $ categoryName c . _category
  "subheading" ## C.textSplice $ _subheading
  "bio"        ## bio

categoryDesc :: MonadSnap n => Categories -> RuntimeSplice n [T.Text]
categoryDesc cs = do
  (Just c) <- lift $ getParam "category"
  let Just (_, Category _ desc _) = lookupCategoryByName c cs
    in return [desc]

category :: MonadSnap n => Categories -> RuntimeSplice n [T.Text]
category cs = do
  (Just c) <- lift $ getParam "category"
  let Just (_, Category name _ _) = lookupCategoryByName c cs
    in return [name]

author :: MonadSnap n => Categories -> Posts -> RuntimeSplice n [T.Text]
author cs ps = do
  (Just c) <- lift $ getParam "category"
  (Just key) <- lift $ getParam "key"
  let Just (categoryAtom, Category{}) = lookupCategoryByName c cs
      (Just (k, _)) = readInt key
      (Just p) = lookupPost categoryAtom (fromIntegral k) ps
    in return [_author p]

postHeader :: MonadSnap n => Categories -> Posts -> Splices (C.Splice n)
postHeader cs ps = do
  "category" ## C.deferMany (C.pureSplice . C.textSplice $ id) $ category cs
  "author"   ## C.deferMany (C.pureSplice . C.textSplice $ id) $ author cs ps

allPostsForCategory :: MonadSnap n => Categories -> Posts -> Splices (C.Splice n)
allPostsForCategory cs ps = do
  "category"     ## C.deferMany (C.pureSplice . C.textSplice $ id) (category cs)
  "categoryDesc" ## C.deferMany (C.pureSplice . C.textSplice $ id) (categoryDesc cs)
  "posts"        ## C.manyWithSplices C.runChildren (splicesFromPost cs) (postsRuntime cs ps)

allPosts :: MonadSnap n => Categories -> Posts -> Splices (C.Splice n)
allPosts cs ps = do
  "allPosts" ## C.manyWithSplices C.runChildren (splicesFromPost cs) (return ps)

bio :: Post -> Builder
bio p =
  case X.parseHTML "bio" (encodeUtf8 $ _bio p) of
    (Right doc) ->
      X.render doc
    (Left e) ->
      C.textSplice id (T.pack e)
