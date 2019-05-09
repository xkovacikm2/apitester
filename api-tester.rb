require 'sinatra'
require 'json'

set :environment, :production
set :port, 4567
set :bind, '0.0.0.0'

storage = []

post '/' do
  data = {
    body: request.body,
    params: params
  }
  storage.push data

  request.body.to_json
end

get '/' do
  storage.to_json
end