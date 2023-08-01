module Traintruck.AST where

type Program = [Instruction]
data Instruction
  = Increment
  | Decrement
  | Prev
  | Next
  | Input
  | Output
  | Loop Program
  deriving Show
