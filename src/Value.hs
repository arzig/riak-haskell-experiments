{-# LANGUAGE FlexibleContexts, UndecidableInstances, OverloadedStrings, DeriveGeneric #-}
module Value where

import              Control.Monad
import              Control.Applicative
import              Data.Aeson
import qualified    Data.Text as T
import qualified    Network.Riak as Riak
import              Network.Riak.Types
import qualified    Data.ByteString.Lazy as L
import              Data.ByteString.Char8
                        (pack) 
import              System.Environment (getArgs)
import              GHC.Generics

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
