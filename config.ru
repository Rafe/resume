require 'sinatra'

get '/' do
  redirect to("/index.html")
end

run Sinatra::Application
