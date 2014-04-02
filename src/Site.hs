{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import Data.ByteString as B
import Data.Maybe
import Snap.Snaplet
import Snap.Core
import Snap.Snaplet.Heist
import Snap.Util.FileServe

------------------------------------------------------------------------------
import  Application

--posts :: [B.ByteString]
--posts = [("haskell", ["test"])]

categoryHandler :: Handler App App ()
categoryHandler = do
  category <- getParam "category"
  title <- getParam "title"
  render $ B.intercalate "/" ["posts", fromJust category, fromJust title]

postHandler :: Handler App App ()
postHandler = do
  category <- getParam "category"
  title <- getParam "title"
  render $ B.intercalate "/" ["posts", fromJust category, fromJust title]

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [("/posts/:category/:title", postHandler)
         ,("/posts/:category", categoryHandler)
         ,("", serveDirectory "static")
         ]

------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "How I Start." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    addRoutes routes
    return $ App h
