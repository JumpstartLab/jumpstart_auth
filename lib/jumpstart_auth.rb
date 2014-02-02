require 'oauth'
require 'twitter'
require 'launchy'
require 'yaml'

class JumpstartAuth
  @@credentials = {
    :consumer_key => "mJ5otbhPGNoDCgCL7j5g",
    :consumer_secret => "M0XkT6GeBnjxdlWHcSGYX1JutMVS9D5ISlkqRfShg"
  }

  def self.client_class
    @client_class ||= Class.new(Twitter::REST::Client) do
      def followers
        follower_ids = Twitter.follower_ids(:cursor => -1).ids
        follower_ids.collect {|id| Twitter.user(id) }
      end

      def friends
        friend_ids = Twitter.friend_ids(:cursor => -1).ids
        friend_ids.collect {|id| Twitter.user(id) }
      end

      def update(message)
        if message.match(/^d\s/i) then
          d, name, *rest = message.chomp.split
          message.sub!(/.*#{name}\s/, '')

          begin
            Twitter.create_direct_message(name, message)
          rescue Twitter::Error::Forbidden
          end
        else
          super(message)
        end
      end
    end
  end
  private_class_method :client_class

  def self.twitter
    setup_oauth unless load_settings

    return client_class.new do |config|
      config.consumer_key = @@credentials[:consumer_key]
      config.consumer_secret = @@credentials[:consumer_secret]
      config.access_token = @@credentials[:access_token]
      config.access_token_secret = @@credentials[:access_token_secret]
    end
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
    @@credentials[:access_token] = access_token.token
    @@credentials[:access_token_secret] = access_token.secret
    write_settings
  end
end
