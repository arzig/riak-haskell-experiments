{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE UndecidableInstances #-}
module Value where

import           Control.Applicative
import           Control.Monad
import           Data.Aeson
import           Data.ByteString.Char8 (pack)
import qualified Data.ByteString.Lazy  as L
import qualified Data.Text             as T
import           GHC.Generics
import qualified Network.Riak          as Riak
import           Network.Riak.Types
import           System.Environment    (getArgs)

data Dummy = Dummy { a :: Double }
    deriving (Show, Generic)

instance ToJSON Dummy

instance FromJSON Dummy

instance (Show Dummy) => Riak.Resolvable Dummy where
    resolve a b = a

byteString :: String -> L.ByteString
byteString s = L.fromChunks ((pack s):[])

main = do
    let client = Riak.defaultClient
    conn <- Riak.connect client
    bucket:key:_ <- getArgs
    res <- Riak.get conn (byteString bucket) (byteString key) Riak.Default :: IO (Maybe (Dummy, VClock))
    putStrLn $ show res
