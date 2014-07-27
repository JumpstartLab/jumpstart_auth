require_relative 'jumpstart_auth/twitter_client'
require_relative 'jumpstart_auth/version'

module JumpstartAuth
  class << self

    def twitter
      TwitterClient.twitter
    end
  end
end
