import Distribution.Simple
import Control.Monad
import System.Environment
import System.Directory
import System.FilePath.Find
import System.FilePath.Posix

import Text.Pandoc

main = defaultMainWithHooks myHooks
  where myHooks = simpleUserHooks { preBuild = myPreBuild }

myPreBuild _ _ = do
  dir   <- getCurrentDirectory
  files <- search "*.md" dir
  forM files convertFileToHtml
  return (Nothing, [])

search pat dir =
  find always (fileName ~~? pat) dir

convertToHtml = (writeHtmlString def{writerHighlight = True
                                    , writerExtensions = githubMarkdownExtensions}) . readMarkdown def

convertFileToHtml file =
  let configFile = replaceExtension file "cfg"
      newFile = replaceExtension file "tpl"
  in
   readFile file >>= writeFile newFile . convertToHtml
