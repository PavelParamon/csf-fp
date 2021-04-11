{-# OPTIONS_GHC -Wno-deferred-type-errors #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Risk where

import Control.Monad.Random
import Data.List

newtype DieValue = DV { unDV :: Int }
    deriving (Eq, Ord, Show, Num)

instance Random DieValue where
  random           = getValFromRand DV . randomR (1,6)
  randomR (low,hi) = getValFromRand DV . randomR (max 1 (unDV low), min 6 (unDV hi))

getValFromRand :: (a -> b) -> (a, c) -> (b, c)
getValFromRand f (randVal, gen) = (f randVal, gen)

die :: Rand StdGen DieValue
die = getRandom

dieAny :: Int -> Rand StdGen [DieValue]
dieAny 0 = return []
dieAny n = do
  x <- die
  xs <- dieAny (n - 1)
  return $ reverse $ sort (x:xs)

type Army = Int

data Battlefield = Battlefield { attackers  
                               , defenders :: Army }
  deriving (Show)

match :: Army -> Army -> [DieValue] -> [DieValue] -> Battlefield
match a d [] _  = Battlefield a d
match a d _ []  = Battlefield a d
match a d (x:xs) (y:ys) 
    | x > y       = match a (d-1) xs ys
    | otherwise   = match (a-1) d xs ys   

battle :: Battlefield -> Rand StdGen Battlefield
battle (Battlefield attackUnitNum defUnitNum) = do
  attackDies <- dieAny (min (attackUnitNum-1) 3)
  defDies <- dieAny (min defUnitNum 2)
  return $ match attackUnitNum defUnitNum attackDies defDies

invade :: Battlefield -> Rand StdGen Battlefield
invade (Battlefield attackUnitNum defUnitNum)  
    | attackUnitNum >= 2 && defUnitNum /= 0 = battle (Battlefield attackUnitNum defUnitNum) >>= \x-> invade x
    | otherwise                             = return $ Battlefield attackUnitNum defUnitNum

successProb :: Battlefield -> Rand StdGen Double
successProb (Battlefield attackerNum defendersNum) = do
  battles <- replicateM 1000 (invade $ Battlefield attackerNum defendersNum)
  return $ sum [1 | x <- battles, defenders x == 0] / 1000 

runGame :: IO ()
runGame = do
  oneBattle <- evalRandIO $ invade (Battlefield 30 20)
  percentWins <- evalRandIO $ successProb (Battlefield 20 30)
  print "One battle"
  print oneBattle
  print "Percent of attacking wins in 1000 battles"
  print percentWins