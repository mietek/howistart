{-# LANGUAGE OverloadedStrings #-}

module CategoryHandler
  ( categoryHandler
  ) where

------------------------------------------------------------------------------
import Control.Monad.State
import Snap.Snaplet
import Snap.Core
import Snap.Snaplet.Heist
import Heist
import qualified Data.ByteString as B
import qualified Heist.Interpreted as I
------------------------------------------------------------------------------
import Application
import Types

categoryHandler :: Handler App App ()
categoryHandler = do
  c <- getParam "category"
  ps <- gets _posts
  cs <- gets _categories
  case lookupCategoryByName c cs of
    Nothing ->
      render ""
    Just (categoryAtom, Category n d _) ->
      renderWithSplices (B.intercalate "/" ["category"])
        (do "category" ## I.textSplice n
            "categoryDesc" ## I.textSplice d
            "posts" ## I.mapSplices (I.runChildrenWith . splicesFromPost cs) (lookupPostsByCategory categoryAtom ps))
