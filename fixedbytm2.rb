require 'rubygems'
require 'sequel'
require 'sinatra'
require 'haml'
# Database configuration and models
require 'models'

require 'sinatra/cache'

# toggle for the cache functionality.
set :cache_enabled, true
# sets the default extension for cached files
set :cache_page_extension, '.html'
# sets the Cache dir to the root of the /public directory.
set :cache_output_dir, '' # was :cache_dir


get '/' do
  count = Fix.count
  @fix = Fix.limit(1, Kernel.rand(count)).first
  haml :fix
end


get '/:id' do
  @fix = Fix.filter(:id => params[:id]).first
  if @fix
    cache haml(:fix)
  else
    redirect '/' 
  end
end

post '/fixes' do
  fix_id = Fix.insert(:text => params[:text], :votes_count => 1)
  FixesUser.insert(:user_id => current_user, :fix_id => fix_id)
  redirect "/#{fix_id}"
end

private

  def current_user
    ip = request["REMOTE_ADDR"]
    if u = User.filter(:ip => ip).first
      return u[:id]
    else
      User.insert(:ip => ip)
    end
  end
  
  # Subverts people's attempts to put in nasty things.
  def h(text)
    text.to_s.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
  end