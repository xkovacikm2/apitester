require 'sinatra'
require 'json'

set :environment, :production
set :port, 4567
set :bind, '0.0.0.0'

storage = []

post '/' do
  data = {
    request: 'POST',
    body: request.body.string,
    params: params
  }
  storage.push data

  request.body.to_json
end

get '/' do
  data = {
    request: 'GET',
    body: request.body.string,
    params: params
  }
  storage.push data

  304
end

get '/get_results' do
  JSON.pretty_generate(storage)
end