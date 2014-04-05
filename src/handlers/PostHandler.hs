{-# LANGUAGE OverloadedStrings #-}

module PostHandler
  ( postHandler
  ) where

------------------------------------------------------------------------------
import Data.Maybe
import Snap.Snaplet
import Snap.Core
import Snap.Snaplet.Heist
import Heist
import Data.Text.Encoding
import qualified Data.Text as T
import qualified Data.ByteString as B
import qualified Heist.Interpreted as I
------------------------------------------------------------------------------
import Application

postHandler :: Handler App App ()
postHandler = do
  c <- getParam "category"
  key <- getParam "key"
  renderWithSplices "post" $ "post" ## postSplice (fromJust c) (fromJust key)

postSplice :: Monad m => B.ByteString -> B.ByteString -> I.Splice m
postSplice category key =
  I.callTemplate (B.intercalate "/" ["posts", (encodeUtf8 (T.toLower (decodeUtf8 category))), key, "index"]) noSplices
