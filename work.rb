require File.join(File.dirname(__FILE__), "util/redis")
require 'resque'

Resque.redis = InflataRedis.redis

module Job
	@queue = :default
	def self.perform(params)
		# 4. given the parameters from /h/hook (in web.rb), do something interesting
		#    asynchronously
		File.open(Time.now.to_s,"w") do |fp|
			fp.write(params["hook_id"])
		end
	end

	def self.do(params)
		Resque.enqueue(Job, params)
	end
end