require "http/client"
require "json"

HEADERS = HTTP::Headers{
  "Client-ID"     => ENV["TWITCH_APP_ID"],
  "Authorization" => "Bearer #{ENV["TWITCH_APP_ACCESS_TOKEN"]}",
  "Content-Type"  => "application/json",
}

def subscribe_to_follows(broadcaster_user_id = "110751694")
  tw_ex_body = {
    "type":      "channel.follow",
    "version":   "1",
    "condition": {
      "broadcaster_user_id": broadcaster_user_id, # "broadcaster_user_id": "12826", # twitch channel id
    },
    "transport": {
      "method":   "webhook",
      "callback": "https://whereisxbotakacharlie.pagekite.me/webhooks/callback",
      # "secret":   ENV["TWITCH_HMAC_KEY"],
      "secret": "the ducks are getting hungry",
    },
  }
  z_body = tw_ex_body.to_json

  response = HTTP::Client.post(
    url: "https://api.twitch.tv/helix/eventsub/subscriptions",
    headers: HEADERS,
    body: z_body,
  )
  p! response.status_code # => 200
  p! JSON.parse(response.body)
end

def get_all_subscriptions
  resp = HTTP::Client.get(
    url: "https://api.twitch.tv/helix/eventsub/subscriptions",
    headers: HEADERS,
  )
  subs = JSON.parse(resp.body).dig?("data")
  if subs
    thingy = [Hash(String, String)]
    i = 0
    while i += 1
    end
  end
end

def delete_a_subscription(id : String)
  HTTP::Client.delete(
    url: "https://api.twitch.tv/helix/eventsub/subscriptions?id=#{id}",
    headers: HEADERS,
  )
end

loop do
  puts <<-HELPER
    what would you like me to do today? (respond with the corresponding number)
    1. subscribe to follows 
    2. get all subscriptions
    3. delete a subscription  
    4. get me outta here! 
    HELPER

  case gets.not_nil!.chomp
  when "1"
    subscribe_to_follows()
  when "2"
    get_all_subscriptions()
  when "3"
    puts "whats the id, duc?"
    id = gets.not_nil!.chomp
    delete_a_subscription(id)
  when "4"
    break
  else
    puts "how'd we get here?"
  end
end
