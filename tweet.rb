require 'twitter'        
require 'yaml'

class Tweet                      
  @queue = :twitter   
  
  def self.perform(tweet)
    config = YAML::load(File.open('twitter.yml'))
    httpauth = Twitter::HTTPAuth.new(config['email'], config['password'])
    client = Twitter::Base.new(httpauth)    
    client.update(tweet)
  end
end