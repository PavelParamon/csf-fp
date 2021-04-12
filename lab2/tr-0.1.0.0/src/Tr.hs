{-# OPTIONS_GHC -Wno-deferred-type-errors #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}
{-# OPTIONS_GHC -Wno-unused-matches #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
module Tr
    ( CharSet
    , tr
    ) where

type CharSet = String

-- | 'tr' - the characters in the first argument are translated into characters
-- in the second argument, where first character in the first CharSet is mapped
-- to the first character in the second CharSet. If the first CharSet is longer
-- than the second CharSet, the last character found in the second CharSet is
-- duplicated until it matches in length.
--
-- If the second CharSet is a `Nothing` value, then 'tr' should run in delete
-- mode where any characters in the input string that match in the first
-- CharSet should be removed.
--
-- The third argument is the string to be translated (i.e., STDIN) and the
-- return type is the output / translated-string (i.e., STDOUT).
-- 
-- translate mode: tr "eo" (Just "oe") "hello" -> "holle"
-- delete mode: tr "e" Nothing "hello" -> "hllo"
--
-- It's up to you how to handle the first argument being the empty string, or
-- the second argument being `Just ""`, we will not be testing this edge case.
isElement :: Char -> CharSet -> Bool 
isElement a [] = False
isElement a (x:xs)
    | a == x = True
    | otherwise = isElement a xs

addChar :: CharSet -> CharSet -> Char -> Char 
addChar (inChar:inset) (outChar:outset) x 
    | x == inChar = outChar
    | otherwise = addChar inset outset x     

replace :: CharSet -> CharSet -> String -> String
replace inset outset xs = reverse $ replaceHelp inset outset xs []
    where
        replaceHelp _ _ [] acc = acc
        replaceHelp inset outset (x:xs) acc =
            if x `isElement` inset  then
                if length outset == length inset then replaceHelp inset outset xs (addChar inset outset x : acc)
                    else replaceHelp inset outset xs (head outset : acc)
            else replaceHelp inset outset xs (x : acc)

delete :: CharSet -> String -> String
delete _ [] = []
delete inset xs = reverse $ deleteHelp inset xs []
    where
        deleteHelp _ [] acc = acc
        deleteHelp inset (x:xs) acc =
            if x `isElement` inset then deleteHelp inset xs acc
            else deleteHelp inset xs (x:acc)

tr :: CharSet -> Maybe CharSet -> String -> String
tr _inset _outset xs = 
    case _outset of
        Just outset -> 
            if outset == "" then xs
                else replace _inset outset xs
        Nothing -> delete _inset xs


