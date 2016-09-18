require 'sinatra'

include FileUtils::Verbose

configure do
  set :port, 8080
  set :static, true
  set :public_folder, "static"
  set :views, "views"
  enable :sessions
end

helpers do
  def img(picture)
    unless picture.is_a?(String)
      "<img src='/images/#{picture[:filename]}' alt='#{picture[:filename]}' />"
    else
      "I can't greet you properly because you didn't upload your picture."
    end
  end
end

get '/' do
  erb :index
end

get '/hello/' do
  erb :hello_form
end

post '/hello/' do
  greeting = params[:greeting] || "Hi there"
  name = params[:name] || "John Doe"
  picture = params[:picture] || "No picture uploaded."

  unless picture.is_a?(String)
    tempfile = params[:picture][:tempfile]
    filename = params[:picture][:filename]
    cp(tempfile.path, "static/images/#{filename}")
  end

  erb :greeting, :locals => {'greeting' => greeting, 
                          'name' => name,
                          'picture' => picture}
end