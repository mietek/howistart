{-# LANGUAGE OverloadedStrings #-}

module PostHandler
  ( postHandler
  ) where

------------------------------------------------------------------------------
import Data.Maybe
import Control.Monad.State
import Snap.Snaplet
import Snap.Core
import Snap.Snaplet.Heist
import Heist
import Data.Text.Encoding
import Data.ByteString.Char8
import qualified Data.Text as T
import qualified Data.ByteString as B
import qualified Heist.Interpreted as I
------------------------------------------------------------------------------
import Application
import Types
import Utils

postHandler :: Handler App App ()
postHandler = do
  infoLog ["handler" <=> "postHandler"]  
  cMaybe <- getParam "category"
  keyMaybe <- getParam "key"
  ps <- gets _posts
  cs <- gets _categories

  fromMaybe serve404 (cMaybe >>= \c ->
                       keyMaybe >>= \keyStr ->
                       readInt keyStr >>= \(k, _) ->
                       lookupCategoryAtom c cs >>= \cAtom ->
                       lookupPost cAtom (fromIntegral k) ps >>= \p ->
                       return $ renderPost c keyStr p)
  where
    renderPost c k p = renderWithSplices "post" $ (do headerSplice c p
                                                      "post" ## postSplice c k)

    serve404 = do
      modifyResponse $ setResponseStatus 404 "Post Not Found"
      renderWithSplices "404" $ "msg" ## I.textSplice "Post Not Found"

postSplice :: Monad m => B.ByteString -> B.ByteString -> I.Splice m
postSplice c k =
  let
    cat = encodeUtf8 (T.toLower (decodeUtf8 c))
  in
   I.callTemplate (B.intercalate "/" ["posts", cat, k, "index"]) noSplices

headerSplice :: Monad n => B.ByteString -> Post -> Splices (I.Splice n)
headerSplice c p = do
  "category" ## I.textSplice (decodeUtf8 c)
  "author"   ## I.textSplice (_author p)
