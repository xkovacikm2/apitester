# This project is libre, and licenced under the terms of the
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
# as published by dtf on July 2019. See the COPYING file or
# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

require 'sinatra'
require 'json'
require 'haml'

set :environment, :production
set :port, 4567
set :bind, '0.0.0.0'

storage = []

get '/flush' do
  storage = []
  haml :flush, format: :html5
end

get '/get_results' do
  haml :results, format: :html5, locals: {storage: storage.map{ |stored| JSON.pretty_generate stored }}
end

put '/*' do
  data = {
    request: 'PUT',
    path: request.path,
    body: process_body(request.body.string),
    params: params,
    headers: request
      .each_header
      .filter{|k,v| k.start_with?('HTTP_')}
      .map{|k,v| [k.sub("HTTP_", ""),v]}
      .to_h
      .merge({
               'Content-Type' => request.get_header('CONTENT_TYPE'),
               'Content-Length' => request.get_header('CONTENT_LENGTH')
             })
  }
  storage.push data

  request.body.to_json
end

post '/*' do
  data = {
    request: 'POST',
    path: request.path,
    body: process_body(request.body.string),
    params: params,
    headers: request
      .each_header
      .filter{|k,v| k.start_with?('HTTP_')}
      .map{|k,v| [k.sub("HTTP_", ""),v]}
      .to_h
      .merge({
        'Content-Type' => request.get_header('CONTENT_TYPE'),
        'Content-Length' => request.get_header('CONTENT_LENGTH')
      })
  }
  storage.push data

  request.body.to_json
end

get '/*' do
  data = {
    request: 'GET',
    path: request.path,
    body: process_body(request.body.string),
    params: params
  }
  storage.push data

  200
end

def process_body(body)
  JSON.parse body rescue body
end

def sanitize(json)
  json
    .gsub('<', '&lt')
    .gsub('>', '&gt')
end
