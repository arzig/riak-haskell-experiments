module Value where

import              Data.String
import qualified    Network.Riak as Riak
import              Network.Riak.Types
import qualified    Data.ByteString.Lazy as L
import              Data.ByteString.Char8
                        (pack) 
import              System.Environment (getArgs)

instance Show String

instance Riak.Resolvable String where
    resolve a b = a

byteString :: String -> L.ByteString
byteString s = L.fromChunks ((pack s):[])

main = do
    let client = Riak.defaultClient
    conn <- Riak.connect client
    bucket:key:_ <- getArgs
    res <- Riak.get conn (byteString bucket) (byteString key) Riak.Default :: IO (Maybe (String, VClock))
    putStrLn $ show res
