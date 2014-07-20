{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import Control.Exception (SomeException)
import Control.Monad.Trans
import Data.Monoid
import Snap.Core
import Snap.Snaplet
import Snap.Snaplet.Heist
import Snap.Util.FileServe
import Heist
import qualified Control.Monad.CatchIO as C
import qualified Data.ByteString as B
------------------------------------------------------------------------------
import Application
import Rss
import Splices
import Types
import Utils
------------------------------------------------------------------------------

routes :: [(B.ByteString, Handler App App ())]
routes = [
  ("/", ifTop $ cRender "index")
  ,("/posts/:category/:key", ifTop postHandler)
  ,("/posts/:category", ifTop $ cRender "category")
  ,("/about", ifTop $ cRender "about")
  ,("/static", serveDirectory "static")
  ]

postHandler :: Handler App App ()
postHandler = do
  infoLog ["handler" <=> "postHandler"]
  (Just c) <- getParam "category"
  (Just k) <- getParam "key"
  cRender $ B.intercalate "/" ["posts", c, k, "index"]

------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "How I Start." Nothing $ do
  f <- liftIO $ Prelude.readFile "app.cfg"
  let (c, p) = read f :: (Categories, Posts)
  liftIO $ writeFile "static/posts.rss" $ rss p
  let config = mempty {
        hcCompiledSplices = (do allCategories
                                postHeader c p
                                allPostsForCategory c p
                                allPosts c p)
        }
  addRoutes routes
  h <- nestSnaplet "" heist $ heistInit "templates"
  wrapSite catch500
  addConfig h config
  return $ App h c p

catch500 :: Handler App App () -> Handler App App ()
catch500 m = (m >> return ()) `C.catch` \(_::SomeException) -> do
  modifyResponse $ setResponseStatus 404 "Page Not Found"
  cRender "404"
