uri = URI.parse("redis://127.0.0.1")
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)