require 'yaml'
require 'redis'

$config = YAML::load(File.open("redis.yml").read)

class InflataRedis
	def self.go
		yield redis
	end

	def self.redis
		uri = URI.parse($config["redis_to_go_url"])
		r = Redis.new(:host => uri.host,
		          :port => uri.port,
		          :password => uri.password,
		          :thread_safe => true)
	end
end