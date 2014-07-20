{-# LANGUAGE OverloadedStrings #-}

module Rss
  ( rss
  ) where


import Data.Maybe
import Network.URI
import Data.Time.Clock
import qualified Data.Text as T
import qualified Text.RSS as R

import Types

rss :: Posts -> String
rss p = R.showXML . R.rssToXML $
        R.RSS "How I Start."
        (fromJust (parseURI "http://www.howistart.org"))
        "How I Start is a mix between a collection of development tutorials and The Setup."
        []
        [ [ R.Title $ (T.unpack $ _title x) ++ " by " ++ (T.unpack $ _author x)
          , R.Link (fromJust (parseURI $ "http://www.howistart.org/posts/" ++ (T.unpack $ _title x) ++ "/" ++ (show $ _key x)))
          , R.Description (T.unpack $ _subheading x)
          , R.PubDate (read (T.unpack $ _published x) :: UTCTime)] | x <- p ]
