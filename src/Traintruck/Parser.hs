module Traintruck.Parser where

import Data.Functor
import Text.Trifecta
import Traintruck.AST

parseBF :: Parser Program
parseBF = program <* eof

program :: Parser Program
program = many comment *> many instruction

comment :: Parser Char
comment = noneOf "+-<>.,[]"

instruction :: Parser Instruction
instruction = choice
  [ char '+' $> Increment
  , char '-' $> Decrement
  , char '<' $> Prev
  , char '>' $> Next
  , char '.' $> Output
  , char ',' $> Input
  , Loop <$> brackets program
  ] <* many comment
