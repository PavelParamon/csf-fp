-- | Test Haskell tr implementation.
--
-- We provide a few very simple tests here as a demonstration. You should add
-- more of your own tests!
--
-- Run the tests with `stack test`.
module Main (main) where

import Test.Hspec
import Test.QuickCheck

import Tr

type CharSet' = NonEmptyList Char

tr' :: CharSet -> CharSet -> String -> String
tr' inset outset = tr inset (Just outset)

trDel inset = tr inset Nothing

-- | Test harness.
main :: IO ()
main = hspec $ describe "Testing tr" $ do
    describe "single translate" $
      it "a -> b" $
        tr' "a" "b" "a" `shouldBe` "b"

    describe "stream translate" $
      it "a -> b" $
        tr' "a" "b" "aaaa" `shouldBe` "bbbb"

    describe "extend input set" $
      it "abc -> d" $
        tr' "abc" "d" "abcd" `shouldBe` "dddd"

    describe "hello" $
      it "hello -> holle" $
        tr' "eo" "oe" "hello" `shouldBe` "holle"

    describe "my test1" $
      it "helleoo -> tolloee" $
        tr' "eoh" "oet" "helleoo" `shouldBe` "tolloee"

    describe "my test2" $
      it "text -> FevF" $
        tr' "xt" "vF" "text" `shouldBe` "FevF" 
    
    describe "delete1" $
      it "hello -> hllo" $
        trDel "e" "hello" `shouldBe` "hllo"

    describe "delete all" $
      it "hello -> " $
        trDel "helo" "hello" `shouldBe` "" 

    describe "delete3" $
      it "hello -> ho" $
        trDel "le" "hello" `shouldBe` "ho"          

    describe "tr quick-check" $
      it "empty input is identity" $ property prop_empty_id

      
-- | An example QuickCheck test. Tests the invariant that `tr` with an empty
-- input string should produce and empty output string.
prop_empty_id :: CharSet' -> CharSet' -> Bool
prop_empty_id (NonEmpty set1) (NonEmpty set2)
  = tr' set1 set2 "" == ""

