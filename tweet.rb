require 'twitter'        
require 'yaml'

class Tweet                      
  @queue = :twitter   
  
  def self.perform(tweet)
    begin
      config = YAML::load(File.open('twitter.yml'))
      httpauth = Twitter::HTTPAuth.new(config['email'], config['password'])
      client = Twitter::Base.new(httpauth)
      client.update(tweet)
    rescue
      sleep 10
      Resque.enqueue(Tweet, tweet)
    end
  end
end