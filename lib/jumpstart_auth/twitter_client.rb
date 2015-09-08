require 'oauth'
require 'twitter'
require 'launchy'
require 'yaml'

module JumpstartAuth
  class TwitterClient < Twitter::REST::Client
    @@credentials = {
      :consumer_key => "mJ5otbhPGNoDCgCL7j5g",
      :consumer_secret => "M0XkT6GeBnjxdlWHcSGYX1JutMVS9D5ISlkqRfShg"
    }

    SETTINGS_FILE = "twitter_settings.yml"

    def followers
      users(follower_ids)
    end

    def friends
      users(friend_ids)
    end

    def update(message)
      if message.match(/^d\s/i) then
        _, name, * = message.chomp.split
        message.sub!(/.*#{name}\s/, '')

        begin
          create_direct_message(name, message)
        rescue Twitter::Error::Forbidden
        end
      else
        super(message)
      end
    end

    def self.twitter
      credentials =  (load_settings or setup_oauth)

      new do |config|
        config.consumer_key        = credentials[:consumer_key]
        config.consumer_secret     = credentials[:consumer_secret]
        config.access_token        = credentials[:access_token]
        config.access_token_secret = credentials[:access_token_secret]
      end
    end

    private

    def self.write_settings
      settings = File.open(SETTINGS_FILE, "w")
      settings << @@credentials.to_yaml
      settings.close

      @@credentials
    end

    def self.load_settings
      return unless File.exist?(SETTINGS_FILE)

      @@credentials = YAML.load(File.open(SETTINGS_FILE, "r"))
    end

    def self.setup_oauth
      consumer = OAuth::Consumer.new( @@credentials[:consumer_key], @@credentials[:consumer_secret], :site => "https://twitter.com")
      request_token = consumer.get_request_token
      printf "Enter the supplied pin: "
      Launchy.open(request_token.authorize_url)
      pin = STDIN.gets.chomp
      access_token = request_token.get_access_token(:oauth_verifier => pin)
      @@credentials[:access_token] = access_token.token
      @@credentials[:access_token_secret] = access_token.secret

      write_settings
    end



    def users(ids)
      ids. each do |id|
        begin
          user(id)
        rescue Twitter::Error::NotFound
          puts "Twitter user #{id}, seems to not exist. Don't worry, we'll keep going"
        end
      end
    end
  end
end
