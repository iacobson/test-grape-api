
 $redis = ConnectionPool.new(size: 5, timeout: 3) { Redis.new(:db => 10) }
