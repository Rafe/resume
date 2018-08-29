require 'sinatra'

set :public_folder, File.join(File.dirname(__FILE__), "/docs")

get '/' do
  redirect to("/index.html")
end

run Sinatra::Application
