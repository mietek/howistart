{-# LANGUAGE OverloadedStrings #-}

module CategoryHandler
  ( categoryHandler
  ) where

------------------------------------------------------------------------------
import Data.Maybe
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
import Utils

categoryHandler :: Handler App App ()
categoryHandler = do
  infoLog ["handler" <=> "categoryHandler"]  
  cMaybe <- getParam "category"
  ps <- gets _posts
  cs <- gets _categories
  fromMaybe serve404 (cMaybe >>= \c ->
                       lookupCategoryByName c cs >>= \(categoryAtom, Category n d _) ->
                       return $ renderCategory n d cs (lookupPostsByCategory categoryAtom ps))
  where
    renderCategory n d cs ps =
      renderWithSplices (B.intercalate "/" ["category"])
      (do "category"     ## I.textSplice n
          "categoryDesc" ## I.textSplice d
          "posts"        ## I.mapSplices (I.runChildrenWith . splicesFromPost cs) ps)

    serve404 = do
      modifyResponse $ setResponseStatus 404 "Category Not Found"
      renderWithSplices "404" $ "msg" ## I.textSplice "Category Not Found"
