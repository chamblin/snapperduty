require 'securerandom'
require File.join(File.dirname(__FILE__), "redis")

class Hook
	# the idea here is we save an endpoint with form params (e.g. email addresses, etc)
	# that we need to figure out what to do in the worker
	def self.create(params = {})
		InflataRedis.go do |redis|
			key = SecureRandom.hex # hopefully random enough
			redis.hmset(key, params.merge("exists" => true).to_a.flatten)
			return key
		end
	end

	# this returns either nil or a hash of the aforementioned parameters
	def self.find(hook_id)
		InflataRedis.go do |redis|
			result = redis.hgetall(hook_id)
			result.empty? ? nil : result
		end
	end
end
