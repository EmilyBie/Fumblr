    
require 'sinatra'
require 'sinatra/reloader'
require './db_config'
require './models/user'
require './models/post'
require './models/comment'

get '/' do
  erb :index
end





