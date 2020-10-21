     
require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end


def run_sql
  db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'wikisolo'})
  result = db.exec(sql)
  db.close
  return result
end


