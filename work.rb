require File.join(File.dirname(__FILE__), "util/redis")
require 'json'
require 'resque'
require 'meme_generator'

Resque.redis = InflataRedis.redis

module Job
	@queue = :default
	def self.perform(params)
		# 4. given the parameters from /h/hook (in web.rb), do something interesting
		#    asynchronously
		PagerDutyJSON.new(params["body"]).incident_descriptions.each do |string|
			MakeAMeme.new(string).make
		end
	end

	def self.do(params)
		Resque.enqueue(Job, params)
	end
end

class PagerDutyJSON
	def initialize(body)
		@body = body
	end

	def incident_descriptions
		incidents.collect{|incident| incident["data"]["incident"]["trigger_summary_data"]["subject"]}
	end

	def incidents
		messages.select{|message| message['type'] == "incident.trigger"}
	end

	def messages
		JSON.parse(@body)["messages"] || []
	end
end

class MakeAMeme
	def initialize(message)
		@message = message
	end

	@@MEMES = { "ned_stark.jpg" => "Brace Yourselves",
		        "bad_luck_brian.jpg" => "Tries to Internet",
		        "first_world_problems.jpg" => "" }

	def make
		meme = @@MEMES.keys.shuffle[0]
		path = File.join(File.dirname(__FILE__), "meme_pics", meme)
		top = @@MEMES[meme]
		bottom = @message
		file = MemeGenerator.generate(path, top, bottom)
	end
end