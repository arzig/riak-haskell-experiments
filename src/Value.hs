{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}

module Value where

import           Control.Applicative
import           Data.Aeson
import           Data.ByteString.Char8 (pack)
import qualified Data.ByteString.Lazy  as L
import           GHC.Generics
import qualified Network.Riak          as Riak
import           Network.Riak.Types

data Dummy = Dummy { a :: Integer }
    deriving (Show, Generic)

instance ToJSON Dummy

instance FromJSON Dummy

instance Riak.Resolvable Dummy where
    resolve x _ = x

byteString :: String -> L.ByteString
byteString s = L.fromChunks ((pack s):[])

fetch :: String -> String -> IO (Maybe (Dummy, VClock))
fetch bucket key = do
    conn <- Riak.connect Riak.defaultClient
    Riak.get conn (byteString bucket) (byteString key) Riak.Default
    
