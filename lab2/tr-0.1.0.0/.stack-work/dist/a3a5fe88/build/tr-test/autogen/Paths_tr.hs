{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_tr (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Pave_\\tr-0.1.0.0\\.stack-work\\install\\0d2ba305\\bin"
libdir     = "C:\\Users\\Pave_\\tr-0.1.0.0\\.stack-work\\install\\0d2ba305\\lib\\x86_64-windows-ghc-8.10.2\\tr-0.1.0.0-KmYzAmf3RV6Gx3ftQjrj4o-tr-test"
dynlibdir  = "C:\\Users\\Pave_\\tr-0.1.0.0\\.stack-work\\install\\0d2ba305\\lib\\x86_64-windows-ghc-8.10.2"
datadir    = "C:\\Users\\Pave_\\tr-0.1.0.0\\.stack-work\\install\\0d2ba305\\share\\x86_64-windows-ghc-8.10.2\\tr-0.1.0.0"
libexecdir = "C:\\Users\\Pave_\\tr-0.1.0.0\\.stack-work\\install\\0d2ba305\\libexec\\x86_64-windows-ghc-8.10.2\\tr-0.1.0.0"
sysconfdir = "C:\\Users\\Pave_\\tr-0.1.0.0\\.stack-work\\install\\0d2ba305\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "tr_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "tr_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "tr_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "tr_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "tr_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "tr_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
