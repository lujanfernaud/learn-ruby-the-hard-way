require 'sinatra'

include FileUtils::Verbose

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

helpers do
  def img(filename)
    "<img src='/images/#{filename}' alt='#{filename}' />"
  end
end

get '/' do
  "Hello world!"
end

get '/hello/' do
  erb :hello_form
end

post '/hello/' do
  greeting = params[:greeting] || "Hi there"
  name = params[:name] || "John Doe"
  picture = params[:picture] || "No picture uploaded."

  tempfile = params[:picture][:tempfile]
  filename = params[:picture][:filename]
  cp(tempfile.path, "static/images/#{filename}")

  erb :index, :locals => {'greeting' => greeting, 
                          'name' => name,
                          'picture' => picture}
end