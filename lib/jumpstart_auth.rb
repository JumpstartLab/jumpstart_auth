require 'oauth'
require 'twitter'
require 'launchy'
require 'yaml'

class JumpstartAuth
  @@credentials = {
    :consumer_key => "mJ5otbhPGNoDCgCL7j5g",
    :consumer_secret => "M0XkT6GeBnjxdlWHcSGYX1JutMVS9D5ISlkqRfShg"
  }

  def self.twitter
    setup_oauth unless load_settings
    Twitter.configure do |config|
      config.consumer_key = @@credentials[:consumer_key]
      config.consumer_secret = @@credentials[:consumer_secret]
      config.oauth_token = @@credentials[:oauth_token]
      config.oauth_token_secret = @@credentials[:oauth_secret]
    end

    return Twitter::Client.new
  end

private

  def self.load_settings
    begin
      @@credentials = YAML.load(File.open("settings.yml", "r"))
    rescue
      false
    end
  end

  def self.write_settings
    settings = File.open("settings.yml", "w")
    settings << @@credentials.to_yaml
    settings.close
  end

  def self.setup_oauth
    consumer = OAuth::Consumer.new( @@credentials[:consumer_key], @@credentials[:consumer_secret], :site => "https://twitter.com")
    request_token = consumer.get_request_token
    printf "Enter the supplied pin: "
    Launchy.open(request_token.authorize_url)
    pin = gets.chomp
    access_token = request_token.get_access_token(:oauth_verifier => pin)
    @@credentials[:oauth_token] = access_token.token
    @@credentials[:oauth_secret] = access_token.secret
    write_settings
  end
end