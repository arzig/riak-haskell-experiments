module Buckets where
    
import qualified Network.Riak as R
import qualified Data.ByteString.Lazy as L

main = do
    let client = R.defaultClient
    conn <- R.connect client
    buckets <- R.listBuckets conn
    print buckets
