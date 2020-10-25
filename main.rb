     
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'bcrypt'

also_reload 'db/data_access.rb' if development?
require_relative 'db/data_access.rb'

enable :sessions

def logged_in? 
  if session[:user_id]
    true 
  else
    false
  end
end

def current_user()
  find_user_by_id(session[:user_id])
end

def create_account(username, email, password)
  password_hash = BCrypt::Password.create(params['password'])
  sql = "INSERT INTO users (username, email, password) VALUES ($1, $2, $3);"
  run_sql(sql, [username, email, password_hash])
end

def user_access(id)
  if current_user['user_id'] == id
    true
  else
    false
  end
end


get '/' do

  posts = all_posts

  erb :index, locals: {
    posts: posts
  }
end


get '/account/new' do
  erb :create_account
end


post '/create_account' do
  create_account(params['username'], params['email'], params['password'])
  redirect '/'
end

get '/solo/new' do
  redirect '/login' unless logged_in?
  erb :new
end


get '/solo/:id' do
  solo = find_post_by_id(params['id'])
  user = find_user_by_id(solo['user_id'])


  erb :details, locals: {
    solo: solo,
    user: user,
  }
end


post '/create' do
  redirect '/login' unless logged_in?
  create_post(params['artist'], params['track'], params['genre'], params['instrument'], params['year'], params['solo_start'], params['youtube_url'], params['soloist'], current_user['user_id'])

  redirect '/'
end


delete '/solo/:id' do
  delete_post(params['id'])
  redirect '/'
end


get '/solo/:id/edit' do

  redirect '/login' unless logged_in? && user_access(params['user_id'])
  
  solo = find_post_by_id(params['id'])

  erb :edit, locals: {
    solo: solo
  }
end


patch '/solo/:id' do
  update_post(params['id'], params['artist'], params['track'], params['genre'], params['instrument'], params['year'], params['solo_start'], params['soloist'])
  redirect "/solo/#{params['id']}"
end


get '/login' do
  erb :login
end


post '/login' do
  user = find_user_by_email(params['email'])

  if BCrypt::Password.new(user['password']).==(params['password'])
    session[:user_id] = user['user_id']
    redirect '/'
  else
    erb :login
  end

end


delete '/logout' do
  session[:user_id] = nil
  redirect '/'
end


get '/about' do
  erb :about
end


get '/browse' do
  erb :browse
end


get '/browse/all' do
  posts = all_posts

  erb :browse_all, locals: {
    posts: posts
  }
end


get '/browse/jazz' do
  jazz_posts = run_sql("SELECT * FROM posts WHERE genre = 'Jazz';")
  erb :jazz, locals: {
    jazz_posts: jazz_posts
  }
end

get '/browse/soul-funk' do
  soul_posts = run_sql("SELECT * FROM posts WHERE genre = 'Soul';")
  funk_posts = run_sql("SELECT * FROM posts WHERE genre = 'Funk';")
  erb :soul_funk, locals: {
    soul_posts: soul_posts,
    funk_posts: funk_posts
  }
end

get '/browse/metal' do
  metal_posts = run_sql("SELECT * FROM posts WHERE genre = 'Metal';")
  erb :metal, locals: {
    metal_posts: metal_posts
  }
end

get '/browse/latin' do
  latin_posts = run_sql("SELECT * FROM posts WHERE genre = 'Latin';")
  erb :latin, locals: {
    latin_posts: latin_posts
  }
end

get '/browse/afro' do
  afro_posts = run_sql("SELECT * FROM posts WHERE genre = 'Afrobeat';")
  erb :afro, locals: {
    afro_posts: afro_posts
  }
end

get '/browse/rock' do
  rock_posts = run_sql("SELECT * FROM posts WHERE genre = 'Rock';")
  erb :rock, locals: {
    rock_posts: rock_posts
  }
end

