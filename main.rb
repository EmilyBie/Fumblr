require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require './db_config'
require './models/user'
require './models/post'
require './models/comment'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user 
  end
end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  erb :index
end

get '/register' do
  erb :register, :layout => :layout_for_user
end
post '/register' do
  
  redirect to '/'
end

get '/login' do
  erb :login , :layout => :layout_for_user
end

get '/posts/new' do
  erb :blog_new
end

get '/about' do
  erb :about
end






