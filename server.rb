require 'sinatra'
require 'json'
require_relative 'lib/signature'


get '/' do
  puts request.query_string

  case request['type']
  when 'validation'
    content_type :json
    return { nonce: request['nonce'] }.to_json
  end
end
