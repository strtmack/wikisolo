     
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


get '/' do

  posts = all_posts

  erb :index, locals: {
    posts: posts
  }
end


get '/solo/new' do
  erb :new
end


get '/solo/:id' do
  solo = find_post_by_id(params['id'])
  user = find_user_by_id(solo['user_id'])

  erb :details, locals: {
    solo: solo,
    user: user
  }
end


post '/create' do
  redirect '/login' unless logged_in?
  create_post(params['artist'], params['track'], params['genre'], params['instrument'], params['year'], params['solo_start'], params['youtube_url'], current_user['id'])

  redirect '/'
end


delete '/solo/:id' do
  delete_post(params['id'])
  redirect '/'
end


get '/solo/:id/edit' do
  solo = find_post_by_id(params['id'])

  erb :edit, locals: {
    solo: solo
  }
end


patch '/solo/:id' do
  update_post(params['id'], params['artist'], params['track'], params['genre'], params['instrument'], params['year'], params['solo_start'], params['youtube_url'])
  redirect "/solo/#{params['id']}"
end


get '/login/' do
  erb :login
end





