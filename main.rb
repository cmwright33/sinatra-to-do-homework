require 'pry'
require 'sinatra'
require 'pg'
require 'sinatra/reloader' if development?


# List todo items
get '/' do
  db = PG.connect(:dbname => 'hw_sinatra', :host => 'localhost')
  sql = "select * from to_do_list"
  @todos = db.exec(sql)
  db.close
  erb :todos
end

# Show the details of a todo
get '/todo/:id' do
  id = params[:id]
  db = PG.connect(:dbname => 'hw_sinatra', :host => 'localhost')
  sql = "SELECT * FROM to_do_list WHERE id = #{id}"
  @todos = db.exec(sql).first
  db.close
  erb :todo
end

# create todo
get '/create_todo' do
  erb :create_todo
end

# Create a todo by sending a POST request to this URL
post '/create_todo' do
  #This will send you to the newly created todo
  redirect to("/todo/#{id}")
end
