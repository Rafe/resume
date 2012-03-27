require 'github/markup'
require 'sinatra'

configure do
  set views: settings.root
end

get '/' do
  redirect to("/index.html")
end

run Sinatra::Application
