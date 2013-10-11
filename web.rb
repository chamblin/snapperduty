require 'sinatra'
require 'haml'
require File.join(File.dirname(__FILE__), "util/hook")
require File.join(File.dirname(__FILE__), "work")

set :bind, '0.0.0.0'
set :port, 8888

get "/" do
	# 1. edit views/index.haml to make a sweet form
	haml :index
end

post "/webhook/create" do
	# 2. pass the params you want to use (they're in params) into Hook.create
	#    we'll refer to them when we get a webhook
	key = Hook.create({})
	@url = hook_url(key)
	haml :created
end

post "/h/:hook_id" do
	# 3. when we receive a webhook, we can use it (see request) +
	#    the parameters provided above to give the worker some parameters
	@hook = Hook.find(params[:hook_id])

	if @hook.nil?
		halt 404, "No such endpoint"
	end

	worker_parameters = {"hook_id" => params[:hook_id], "body" => request.body.read} # fill in the blanks here

	Job.do(worker_parameters)

	halt 200
end

helpers do
	def hook_url(hook_id)
		"%s/h/%s" % [request.base_url, hook_id]
	end
end
