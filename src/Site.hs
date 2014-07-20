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
--import Control.Applicative
import Control.Exception (SomeException)
import qualified Control.Monad.CatchIO as C
import Control.Monad.Trans
import Data.Maybe
import Data.Monoid

import Snap.Core
import Snap.Snaplet
import Snap.Snaplet.Heist
import Snap.Util.FileServe
import Heist
import qualified Data.Text as T
import qualified Data.ByteString as B
import qualified Text.RSS as R
import Network.URI
import Data.Time.Clock
------------------------------------------------------------------------------
import Application
import Types
import Utils
import Splices
------------------------------------------------------------------------------

routes :: [(B.ByteString, Handler App App ())]
routes = [
  ("/", ifTop $ cRender "index")
  ,("/posts/:category/:key", ifTop postHandler)
  ,("/posts/:category", ifTop $ cRender "category")
  ,("/about", ifTop $ cRender "about")
  ,("/static", serveDirectory "static")
  ,("", fourOhFour)
  ]

postHandler :: Handler App App ()
postHandler = do
  infoLog ["handler" <=> "postHandler"]
  (Just c) <- getParam "category"
  (Just k) <- getParam "key"
  cRender $ B.intercalate "/" ["posts", c, k, "index"]

fourOhFour :: Handler App App ()
fourOhFour = do
  modifyResponse $ setResponseStatus 404 "Post Not Found"
  cRender "404"

------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "How I Start." Nothing $ do
  f <- liftIO $ Prelude.readFile "app.cfg"
  let (c, p) = read f :: (Categories, Posts)
  liftIO $ writeFile "static/posts.rss" $ R.showXML . R.rssToXML $ rss p
  let config = mempty {
        hcCompiledSplices = (do allCategories
                                postHeader c p
                                allPostsForCategory c p
                                allPosts c p)
        }
  addRoutes routes
  h <- nestSnaplet "" heist $ heistInit "templates"
  --wrapSite (\hs -> catch500 hs <|> hs)
  wrapSite catch500
  addConfig h config
  return $ App h c p

rss :: Posts -> R.RSS
rss p = R.RSS "How I Start."
            (fromJust (parseURI "http://www.howistart.org"))
            "How I Start is a mix between a collection of development tutorials and The Setup."
            []
            [ [ R.Title $ (T.unpack $ _title x) ++ " by " ++ (T.unpack $ _author x)
               , R.Link (fromJust (parseURI $ "http://www.howistart.org/posts/" ++ (T.unpack $ _title x) ++ "/" ++ (show $ _key x)))
               , R.Description (T.unpack $ _subheading x)
               , R.PubDate (read (T.unpack $ _published x) :: UTCTime)] | x <- p
             ]

catch500 :: Handler App App () -> Handler App App ()
catch500 m = (m >> return ()) `C.catch` \(_::SomeException) -> do
  modifyResponse $ setResponseStatus 404 "Page Not Found"
  cRender "404"
