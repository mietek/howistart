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

------------------------------------------------------------------------------
import Application
import Types
import PostHandler as P
import CategoryHandler as C

------------------------------------------------------------------------------
routes :: [(B.ByteString, Handler App App ())]
routes = [
  ("/", ifTop indexHandler)
  ,("/posts/:category/:key", P.postHandler)
  ,("/posts/:category", ifTop C.categoryHandler)
  ,("", serveDirectory "static")
  ]

indexHandler :: Handler App App ()
indexHandler = do
  cs <- gets _categories
  ps <- gets _posts
  renderWithSplices (B.intercalate "/" ["index"])
      (do "posts" ## I.mapSplices (I.runChildrenWith . splicesFromPost cs) ps)

renderList :: T.Text -> [T.Text] -> SnapletISplice App
renderList label = I.mapSplices (\x -> I.runChildrenWith (label ## I.textSplice x))

------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "How I Start." Nothing $ do
  f <- liftIO $ Prelude.readFile "app.cfg"
  let p = read f :: Posts
  let c = [(Haskell, Category "haskell" "Pure functional language." "http://haskell.org")
          ,(Erlang, Category "erlang" "Concurrent functional language." "http://erlang.org")
          ,(Elixir, Category "elixir" "Functional, meta-programming aware language built on top of the Erlang VM." "http://elixir-lang.org")]
  let categoryNames = [name | (_, Category name _ _) <- c]
  let config = mempty {
        hcInterpretedSplices = "categories" ## (renderList "category" categoryNames)
        }
  addRoutes routes
  h <- nestSnaplet "" heist $ heistInit "templates"
  addConfig h config
  return $ App h c p
