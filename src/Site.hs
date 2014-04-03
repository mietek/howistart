{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
    , Post(..)
  ) where

------------------------------------------------------------------------------
import Control.Monad.Trans
import Data.ByteString as B
import Data.Maybe
import Data.Monoid
import Snap.Snaplet
import Snap.Core
import Snap.Snaplet.Heist
import Snap.Util.FileServe
import Heist
import Data.Text.Encoding
import qualified Data.Text as T
import qualified Heist.Interpreted as I
------------------------------------------------------------------------------
import  Application

data Post = Post {
  title :: T.Text
  , author :: T.Text
  , category :: T.Text
  } deriving (Show, Read)

type Posts = [Post]

posts :: Maybe ByteString -> [T.Text]
posts _ = ["My Post"]

categoryHandler :: Handler App App ()
categoryHandler = do
  c <- getParam "category"
  renderWithSplices (B.intercalate "/" ["category"])
    (do "category" ## I.textSplice (decodeUtf8 (fromJust c))
        "posts" ## renderList "title" (posts c))

postHandler :: Handler App App ()
postHandler = do
  c <- getParam "category"
  t <- getParam "title"
  render $ B.intercalate "/" ["posts", fromJust c, fromJust t]

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [("/posts/:category/:title", postHandler)
         ,("/posts/:category", categoryHandler)
         ,("", serveDirectory "static")
         ]

renderList :: T.Text -> [T.Text] -> SnapletISplice App
renderList label = I.mapSplices (\x -> I.runChildrenWith (label ## I.textSplice x))

categories :: [T.Text]
categories = ["Erlang", "Elixir", "Haskell"]

------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "How I Start." Nothing $ do
  f <- liftIO $ Prelude.readFile "/home/tristan/Devel/howistart/app.cfg"
  let p = read f :: Posts
  let config = mempty {
        hcInterpretedSplices = "categories" ## (renderList "category" categories)
        }
  h <- nestSnaplet "" heist $ heistInit "templates"
  addConfig h config
  addRoutes routes
  return $ App h
