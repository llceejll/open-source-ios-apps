require 'delete_my_tweets'

c = {
               "consumer_key" => ENV.fetch('TWITTER_CONSUMER_KEY'),
            "consumer_secret" => ENV.fetch('TWITTER_CONSUMER_SECRET'),
               "access_token" => ENV.fetch('TWITTER_ACCESS_TOKEN'),
        "access_token_secret" => ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET'),
                     "filter" => {
            "exclude" => [
                "Add",
                "add"
            ]
        }
    }

DeleteMyTweets.twitter_delete(c) do |o|
  puts o
end
puts 'all done 🐤'
