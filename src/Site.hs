{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import Control.Monad.Trans
import Control.Monad.State
import Data.Monoid
import Snap.Core
import Snap.Snaplet
import Snap.Snaplet.Heist
import Snap.Util.FileServe
import Heist
import qualified Data.Text as T
import qualified Data.ByteString as B
import qualified Heist.Interpreted as I

import qualified Text.RSS as R
import Data.Maybe
import Network.URI
import Data.Time.Clock

------------------------------------------------------------------------------
import Application
import Types
import Utils
import PostHandler as P
import CategoryHandler as C

------------------------------------------------------------------------------
routes :: [(B.ByteString, Handler App App ())]
routes = [
  ("/", ifTop indexHandler)
  ,("/posts/:category/:key", ifTop P.postHandler)
  ,("/posts/:category", ifTop C.categoryHandler)
  ,("/about", ifTop $ render "about")
  ,("/static", serveDirectory "static")
  ]

indexHandler :: Handler App App ()
indexHandler = do
  infoLog ["handler" <=> "indexHandler"]
  cs <- gets _categories
  ps <- gets _posts
  renderWithSplices (B.intercalate "/" ["index"])
      ("posts" ## I.mapSplices (I.runChildrenWith . splicesFromPost cs) ps)

renderList :: T.Text -> [T.Text] -> SnapletISplice App
renderList label = I.mapSplices (\x -> I.runChildrenWith (label ## I.textSplice x))

------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "How I Start." Nothing $ do
  f <- liftIO $ Prelude.readFile "app.cfg"
  let (c, p) = read f :: (Categories, Posts)
  liftIO $ writeFile "static/posts.rss" $ R.showXML . R.rssToXML $ rss p
  let categoryNames = [name | (_, Category name _ _) <- c]
  let config = mempty {
        hcInterpretedSplices = "categories" ## renderList "category" categoryNames
        }
  addRoutes routes
  h <- nestSnaplet "" heist $ heistInit "templates"
  addConfig h config
  return $ App h c p

rss :: Posts -> R.RSS
rss p = R.RSS "How I Start."
            (fromJust (parseURI "http://www.howistart.org"))
            "How I Start is a mix between a collection of development tutorials and The Setup."
            []
            [ [ R.Title $ (T.unpack $ _title x) ++ " by " ++ (T.unpack $ _author x)
               , R.Link (fromJust (parseURI $ "http://www.howistart.org/posts/" ++ (T.unpack (_title x)) ++ "/" ++ (show (_key x))))
               , R.Description (T.unpack $ _subheading x)
               , R.PubDate (read (T.unpack $ _published x) :: UTCTime)] | x <- p
             ]
