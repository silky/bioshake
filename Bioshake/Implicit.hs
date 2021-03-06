{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE Rank2Types            #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE UndecidableInstances  #-}
-- | This modules provides implicit parameters, intended for passing default and overrideable configuration options. It is based on implicit-params in hackage.
module Bioshake.Implicit where

import           Unsafe.Coerce

class Default a where
  def :: a

class Implicit a where
  param :: a

newtype Param a b = Param (Implicit a => b)

setParam :: forall a b. a -> (Implicit a => b) -> b
setParam a f = unsafeCoerce (Param f :: Param a b) a
{-# INLINE setParam #-}

($~) :: forall a b. (Implicit a => b) -> a -> b
($~) f = unsafeCoerce (Param f :: Param a b)
infixl 1 $~
{-# INLINE ($~) #-}

instance Default a => Implicit a where param = def
