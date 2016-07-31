require 'sinatra'

include FileUtils::Verbose

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

get '/' do
  "Hello world!"
end

get '/hello/' do
  erb :hello_form
end

post '/hello/' do
  greeting = params[:greeting] || "Hi there"
  name = params[:name] || "Nobody"

  erb :index, :locals => {'greeting' => greeting, 'name' => name}
end

get '/upload/' do
  erb :upload
end

post '/upload/' do
  tempfile = params[:picture][:tempfile]
  filename = params[:picture][:filename]
  cp(tempfile.path, "static/uploads/#{filename}")
end