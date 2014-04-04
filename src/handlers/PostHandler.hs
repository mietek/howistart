{-# LANGUAGE OverloadedStrings #-}

module PostHandler
  ( postHandler
  ) where

------------------------------------------------------------------------------
import Data.Maybe
import Snap.Snaplet
import Snap.Core
import Snap.Snaplet.Heist
import qualified Data.ByteString as B
------------------------------------------------------------------------------
import Application

postHandler :: Handler App App ()
postHandler = do
  c <- getParam "category"
  t <- getParam "title"
  render $ B.intercalate "/" ["posts", fromJust c, fromJust t]
