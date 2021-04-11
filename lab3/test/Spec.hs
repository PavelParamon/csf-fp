module Main (main) where

import Test.Hspec
import Test.QuickCheck
import Control.Monad.Random
import Control.Monad
import Data.List
import System.IO.Unsafe

import Risk

main :: IO ()
main = hspec $ describe "Testing excercises" $ do
    --describe "Excercise 2" $
      --it "Army decrease" $ 
        --(battle (Battlefield 10 10) >>= \bf -> checkDecrease (10, 10) bf) `shouldBe` True
    describe "Excercise 2" $
      it "Army reduction" $
        checkReduction (10, 10) (unsafePerformIO . evalRandIO $ battle (Battlefield 10 10))

    describe "Excercise 3" $
      it "Army all kills" $ 
        checkAllKills $ unsafePerformIO . evalRandIO $ invade (Battlefield 10 10)

    describe "Excercise 4" $
      it "attackers wins" $
        (unsafePerformIO . evalRandIO $ successProb $ Battlefield 10 0) `shouldBe` 1.0

    describe "Excercise 4" $
      it "defenders wins" $
         (unsafePerformIO . evalRandIO $ successProb $ Battlefield 0 10) `shouldBe` 0.0

    describe "Excercise 4" $
      it "Percent from 0 to 1" $
         fromTo $ unsafePerformIO . evalRandIO $ successProb $ Battlefield 10 10   
            

fromTo :: Double -> Bool 
fromTo val = val >= 0.0 && val <= 1.0

checkReduction :: (Army, Army) -> Battlefield -> Bool
checkReduction (a, d) bf = attackers bf < a || defenders bf < d

checkAllKills :: Battlefield -> Bool
checkAllKills bf = attackers bf == 1 || defenders bf == 0