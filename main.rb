require 'sinatra'
# require 'sinatra/reloader'
# require 'pry'
require './db_config'
require './models/user'
require './models/post'
require './models/comment'
require './models/post_type'
require './models/tag'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user 
  end

  def all_tags
    PostType.all?
  end

end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  # if !logged_in?
  #   @posts = Post.all.take(20)
  # else 
  #   tags = current_user.tags
  #   @posts = PostType.
  # end
  
  @posts = Post.all
  erb :index
end

get '/posts/myblog' do
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
  
  redirect to '/add_tags'
end

get '/add_tags' do 
  @post_types = PostType.all
  erb :add_tags, :layout => :layout_for_user
end

get '/login' do
  erb :login , :layout => :layout_for_user
end

get '/select_one_tag/:post_type_id' do
  tag = Tag.find_by(user_id: current_user.id,post_type_id:params[:post_type_id])
  if tag == nil
    tag = Tag.new
    tag.post_type_id = params[:post_type_id]
    tag.user_id = current_user.id
    tag.save
  else 
    Tag.destroy(tag.id)
  end
  redirect to '/add_tags' 
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
  @post_types = PostType.all
  @post = Post.new
  erb :blog_new
end

post '/posts/new' do

  if params[:id] != nil && params[:id] != ''
    post = Post.find(params[:id])
  else 
    post = Post.new
  end
  post.user_id = session[:user_id]
  post.title = params[:title]
  post.body = params[:body]
  if (post.body.split(" ").size/130).floor != 0
    post.reading_time = (post.body.split(" ").size/130).floor
  else
    post.reading_time = 1
  end
  post.post_time = Time.now
  post.post_type_id = params[:post_types]
  post.image_url = params[:image]
  if post.valid?
    post.save
  else
    redirect to '/posts/new'
  end
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
  comment = Comment.new
  comment.post_id = params[:post_id]
  comment.body = params[:body]
  if comment.valid? == true
      comment.save
  end
  redirect to "/posts/show?id=#{params[:post_id]}"
end

get '/posts/like' do
  post = Post.find(params[:post_id])
  if !logged_in?
    redirect to '/login'
  end
  if post.liked_by == nil
    post.liked_by = []
    post.liked_by.push(current_user.id)
    post.likes = 0
    post.likes += 1
  elsif post.liked_by.include?(current_user.id) == true
    post.liked_by.delete(current_user.id)
    post.likes -= 1
  else  
    post.liked_by.push(current_user.id)
    post.likes += 1
  end
  post.save
  redirect to '/'
end

get '/posts/topstories' do
  @posts = Post.where.not(likes: nil).order("likes DESC").take(10)
  erb :index
end

delete '/blog/delete/:id' do
  post = Post.find(params[:id])
  post.destroy
  redirect to '/posts/myblog'
end

get '/blog/edit/:id' do
  @post = Post.find(params[:id])
  @post_types = PostType.all
  erb :blog_new
end

get '/search' do
  @posts = Post.where("title like ?", "%" + params[:keyword] + "%")
  erb :index
end






