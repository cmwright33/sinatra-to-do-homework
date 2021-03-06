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

# Create a todo by sending a POST request to this URL
post '/' do
  id = params[:id]
  task = params[:task]
  task_description = params[:task_description]
  completed = params[:completed]
  db = PG.connect(:dbname => 'hw_sinatra', :host => 'localhost')
  sql = "insert into to_do_list (task, task_description, completed) values ('#{task}', '#{task_description}', #{completed})"
  @todos = db.exec(sql)
  db.close
  #This will send you to the newly created todo
  redirect to("/todo/#{id}")
end

# this deletes the task and redirects you back to the main page
post '/todo/:id/delete' do
  id = params[:id]
  db = PG.connect(:dbname => 'hw_sinatra', :host => 'localhost')
  sql = "delete from to_do_list where id = #{id}"
  db.exec(sql)
  db.close
  redirect to "/"
end
# this route sends you to the edit page for a specific task
# selects from a todo list where the id matchs the id already given.
# and sends the id to the form page
get '/todo/:id/edit' do
  id = params[:id]
  db = PG.connect(:dbname => 'hw_sinatra', :host => 'localhost')
  sql = "select * from to_do_list where id = #{id}"
  @todo = db.exec(sql).first
  db.close
  erb :edit
end

# sends you to the create_todo.erb form
get '/create_todo' do
  erb :create_todo
end

# Show the details of a task
get '/todo/:id' do
  id = params[:id]
  db = PG.connect(:dbname => 'hw_sinatra', :host => 'localhost')
  sql = "select * from to_do_list where id =#{id}"
  @todo = db.exec(sql).first
  db.close
  erb :todo
end

# this route takes the edit and updates the task by its specific id
# posts the the information from the edit form
post '/todo/:id' do
  id = params[:id]
  task = params[:task]
  task_description = params[:task_description]
  completed = params[:completed]
  db = PG.connect(:dbname => 'hw_sinatra', :host => 'localhost')
  sql = "update to_do_list set (task, task_description, completed) = ('#{task}', '#{task_description}',#{completed}) WHERE id = #{id}"
  db.exec(sql)
  db.close
end
