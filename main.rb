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
  if !logged_in?
    @posts = []
  else
    @posts = Post.where(user_id:current_user.id).order("post_time DESC")
  end
  erb :index
end

get '/register' do
  erb :register, :layout => :layout_for_user
end
post '/register' do
  user = User.new
  user.email = params[:email]
  if params[:password] != params[:confirm_password]
    redirect to '/register'
  end
  user.password = params[:password]
  user.save
  redirect to '/'
end

get '/login' do
  erb :login , :layout => :layout_for_user
end

post '/login' do
  user = User.find_by(email:params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect to '/'
  else 
    redirect to '/login'
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect to '/'
end

get '/posts/new' do
  erb :blog_new
end

post '/posts/new' do
  post = Post.new
  post.user_id = session[:user_id]
  post.title = params[:title]
  post.body = params[:body]
  if (post.body.split(" ").size/130).floor != 0
    post.reading_time = (post.body.split(" ").size/130).floor
  else
    post.reading_time = 1
  end
  post.post_time = Time.now
  post.save
  redirect to '/'
end

get '/posts/show' do
  @post = Post.find(params[:id])
  @comments = Comment.where(post_id:params[:id])
  erb :show_blog_detail
end

get '/about' do
  erb :about
end

post '/comment/' do
  Comment.create(post_id: params[:post_id],body:params[:body])
  redirect to "/posts/show?id=#{params[:post_id]}"
end

get '/posts/like' do
  post = Post.find(params[:post_id])
  if post.liked_by == nil
    post.liked_by = []
    post.liked_by.push(current_user.id)
  elsif post.liked_by.include?(current_user.id) == true
    post.liked_by.delete(current_user.id)
  else  
    post.liked_by.push(current_user.id)
  end
  post.save
  redirect to '/'
end





