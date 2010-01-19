require 'rubygems'
require 'sequel'
require 'sinatra'
require 'haml'   
require 'resque'      
require 'tweet'     
# Database configuration and models
require 'models'  



# require 'sinatra/cache'

# toggle for the cache functionality.
# set :cache_enabled, true
# sets the default extension for cached files
# set :cache_page_extension, '.html'
# sets the Cache dir to the root of the /public directory.
# set :cache_output_dir, '' # was :cache_dir


get '/' do
  count = Fail.count
  @fail = Fail.limit(1, Kernel.rand(count)).first
  haml :fail
end

get '/about' do
  
end

get '/style.css' do
  "html, body { 
    height: 100%; 
  } 

  #container { 
    min-height: 100%; 
  } 

  * html #container { 
    height:  100%; 
  }

  body {
    background: #EB088C;
    font: 14pt Helvetica;
    color: white;
  }

  a {
    color: #FFFFFF; 
    text-decoration: underline;
    font-style: italic;
  }

  .fail h1 {
    font-size:64pt;
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
    text-align: right;
    clear: both;
  }
  "
end


get '/:id' do
  @hide_count = true
  @fail = Fail.filter(:id => params[:id]).first
  if @fail
    # cache haml(:fix)
    haml(:fail)
  else
    redirect '/' 
  end
end

post '/fails' do
  if fail = Fail.filter(:text => params[:text]).first
    redirect "/#{fail[:id]}"
  else
    fail_id = Fail.insert(:text => params[:text], :votes_count => 1)
    FailsUser.insert(:user_id => current_user, :fail_id => fail_id) 
    Resque.enqueue(Tweet, "#{params[:text]} door de OV-chipkaart" )
  end
  redirect "/#{fail_id}"
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