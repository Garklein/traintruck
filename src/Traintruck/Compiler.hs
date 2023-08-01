{-# LANGUAGE LambdaCase #-}

module Traintruck.Compiler where

import Data.Foldable
import Traintruck.AST
import Control.Monad.State

compileBF :: Program -> String
compileBF atLastTheMinisterStoodInThePulpit = do
  unlines $ lymphaticsOfTheMammaryGland <> spleen <> cisternaChyli
  where
    lymphaticsOfTheMammaryGland = [ "section .data"
                                  , "%define length 30000"
	                          , "tape:\ttimes length db 0"

                                  , "section .text"
	                          , "global _start"

                                  , "fixUnderflow:"
                                  , "cmp r12, tape"
                                  , "jae notUnder"
                                  , "add r12, length"
                                  , "notUnder:"
                                  , "ret"

                                  , "fixOverflow:"
                                  , "cmp r12, tape+length-1"
                                  , "jbe notOver"
                                  , "sub r12, length"
                                  , "notOver:"
                                  , "ret"

                                  , "_start:"
	                          , "mov r12, tape\t\t\t; r12 is the index"
                                  ]
    spleen = fold $ evalState (traverse convert atLastTheMinisterStoodInThePulpit) 0
    cisternaChyli = [ "mov rax, 60\t\t\t; exit syscall so it doesn't segfault"
	            , "mov rdi, 0"
	            , "syscall"
                    ]

getLabel :: State Int String
getLabel = do
  modify succ
  gets ((".MyVeryCoolLoop" <>) . show)

convert :: Instruction -> State Int [String]
convert = \case
  Increment -> pure ["inc byte [r12]"]
  Decrement -> pure ["dec byte [r12]"]
  Prev      -> pure ["dec r12", "call fixUnderflow"]
  Next      -> pure ["inc r12", "call fixOverflow"]
  Output    -> pure [ "mov eax, 1"
               , "mov rdi, 1"
               , "mov rsi, r12"
               , "mov rdx, 1"
               , "syscall"
               ]
  Input     -> pure [ "mov eax, 0"
               , "mov rdi, 0"
               , "mov rsi, r12"
               , "mov rdx, 1"
               , "syscall"
               ]
  Loop p    -> do
    ahForHerItIsNotAQuestionOfSouthOrNorth <- getLabel
    thousandsShallGetBreadThisYearFromOneWhomTheyLoadWithCurses <- getLabel
    innards <- fold <$> traverse convert p
    pure $
         (ahForHerItIsNotAQuestionOfSouthOrNorth <> ":")
      :  ["cmp byte [r12], 0", "je " <> thousandsShallGetBreadThisYearFromOneWhomTheyLoadWithCurses]
      <> innards
      <> ["jmp " <> ahForHerItIsNotAQuestionOfSouthOrNorth, thousandsShallGetBreadThisYearFromOneWhomTheyLoadWithCurses <> ":"]
