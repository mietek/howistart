{-# LANGUAGE OverloadedStrings #-}

module Utils
       ( infoLog
       , (<=>)
       ) where

import Snap.Core
import Data.Text.Encoding
import qualified Data.Text as T
import qualified Data.ByteString.Char8 as B

(<=>) :: (Show a) => B.ByteString -> a -> (B.ByteString, B.ByteString)
(<=>) x y = (x, showBS y)

infoLog :: (MonadSnap m) => [(B.ByteString, B.ByteString)] -> m()
infoLog l = logError $ B.append ("[INFO] ") $
            B.intercalate " " $ map (\(x,y) -> B.concat [x, "=", y]) l

showBS :: (Show a) => a -> B.ByteString
showBS = encodeUtf8 . T.pack . show
