{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import Shelly
import Distribution.Simple
import Control.Monad
import System.Environment
import System.Directory
import System.FilePath.Find as F
import System.FilePath.Posix
import qualified Data.Text as T
import Text.Pandoc

main = defaultMainWithHooks myHooks
  where myHooks = simpleUserHooks { preBuild = myPreBuild }

myPreBuild _ _ = do
  dir   <- getCurrentDirectory
  files <- search "*.md" $ joinPath [dir, "snaplets", "heist", "templates", "posts"]
  forM files convertFileToHtml
  return (Nothing, [])

search pat dir =
  F.find always (fileName ~~? pat) dir

convertToHtml = (writeHtmlString def{writerHighlight = True
                                    , writerExtensions = githubMarkdownExtensions}) . readMarkdown def

convertFileToHtml file =
  let newFile = replaceExtension file "tpl"
      dir = takeDirectory file
  in do
    copy_images (fromText $ T.pack $ joinPath [dir, "images"])
    writeFile newFile "<apply template='post'><bind tag='post'>"
    readFile file >>= appendFile newFile . convertToHtml
    appendFile newFile "</bind></apply>"

copy_images dir = shelly $ verbosely $ do
  exists <- test_d dir
  case exists of
    True -> do
      let sp = splitPath $ T.unpack (toTextIgnore dir)
      let path = joinPath (init $ drop (length sp - 3) sp)
      let newPath = fromText $ T.pack $ joinPath ["static", "images", path]
      mkdir_p newPath
      images <- ls dir
      mapM_ (\f -> cp_r f newPath) images
      return ()
    False ->
      return ()
