{-# LANGUAGE LambdaCase #-}

module Main where

import Text.Trifecta
import Control.Arrow
import Traintruck.Parser
import Traintruck.Compiler

main :: IO ()
main = getContents >>= (runParser parseBF mempty >>> \case
  Success s -> putStrLn $ compileBF s
  Failure s -> print s)
