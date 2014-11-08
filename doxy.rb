#!/usr/bin/ruby

require 'sinatra'
require 'json'
require 'erb'

set :bind, '0.0.0.0'
 
my_ip='98.203.170.173'
web_port='4567'
tenant_id='what'
is_admin = 0
role = 'admin'
username = nil
server_name = nil
post '/v2.0/tokens' do
	content_type 'application/json'
	json_data = JSON.parse request.body.read
	tenant_id = json_data["auth"]["tenantId"]
	username = json_data["auth"]["passwordCredentials"]["username"]
	if username =~ /admin/
		role = 'admin'
		is_admin = 1
	else
		role = 'Member'
		is_admin = 0
	end
	template = ERB.new File.new("templates/tokens.erb").read, nil, "%"
	result = JSON.parse template.result()
	JSON.generate(result)
end

get '/' do
	content_type 'application/json'
	template = ERB.new File.new("templates/image_root.erb").read, nil, "%"
	result = JSON.parse template.result()
	JSON.generate(result)
end

get '/compute/v2/flavors/detail' do
	content_type 'application/json'
	template = ERB.new File.new("templates/compute_flavor.erb").read, nil, "%"
	result = JSON.parse template.result()
	JSON.generate(result)
end

get '/image/v1/images/detail' do
	content_type 'application/json'
	template = ERB.new File.new("templates/image_detail.erb").read, nil, "%"
	result = JSON.parse template.result()
	JSON.generate(result)
end

post '/compute/v2/servers' do
	content_type 'application/json'
	json_data = JSON.parse request.body.read
	server_name = json_data["server"]["name"]
	template = ERB.new File.new("templates/compute_server.erb").read, nil, "%"
	result = JSON.parse template.result()
	JSON.generate(result)
end

get '/compute/v2/servers/:server_name' do
	server_name = params[:server_name]
	content_type 'application/json'
	template = ERB.new File.new("templates/compute_get_server.erb").read, nil, "%"
	result = JSON.parse template.result()
	JSON.generate(result)
end


get '/compute/v2/servers/:server_name/os-security-groups' do
	content_type 'application/json'
	template = ERB.new File.new("templates/compute_server_sec_group.erb").read, nil, "%"
	result = JSON.parse template.result()
	JSON.generate(result)
end
