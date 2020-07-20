require 'sinatra'
require 'json'

set :environment, :production
set :port, 4567
set :bind, '0.0.0.0'

storage = []

post '/' do
  data = {
    request: 'POST',
    body: process_body(request.body.string),
    params: params
  }
  storage.push data

  request.body.to_json
end

get '/' do
  data = {
    request: 'GET',
    body: process_body(request.body.string),
    params: params
  }
  storage.push data

  304
end

get '/flush' do
  storage = []
  "Storage flushed, enjoy clear screen"
end

get '/get_results' do
  "<pre>
  #{JSON.pretty_generate storage}
  </pre>"
end

def process_body(body)
  JSON.parse body rescue body
end
