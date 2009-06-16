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

get '/style.css' do
  "body {
    background: #4d085b;
    font: 14pt Helvetica;
    color: white;
  }

  a {
    color: #FF5CD4;
    text-decoration: underline;
  }

  .fix h1 {
    font-size:72pt;
  }

  .yours { 
    color: #97377d;
    padding: 10px;
    -webkit-border-radius: 15px;
    -moz-border-radius: 15px;
    width: 50%;
    background: white;
  }

  .yours textarea { 
    width: 75%;
    height: 4em;
    font-size: 24pt;
  }

  #footer {
    position: absolute;
    bottom: 5px;
    right: 5px;
    font-size: 75%;
    margin-top: 50pt;
  }
  "
end


get '/:id' do
  @hide_count = true
  @fix = Fix.filter(:id => params[:id]).first
  if @fix
    cache haml(:fix)
  else
    redirect '/' 
  end
end

post '/fixes' do
  if fix = Fix.filter(:text => params[:text]).first
    redirect "/#{fix[:id]}"
  else
    fix_id = Fix.insert(:text => params[:text], :votes_count => 1)
    FixesUser.insert(:user_id => current_user, :fix_id => fix_id)
  end
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