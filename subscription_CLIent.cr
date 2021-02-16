require "http/client"
require "json"

# MVP:
# assume user has:
#   - client id
#   - auth token
#   - broadcaster_user_id
# first post MVP feature:
#     we delagate to twitch-cli to retrieve above info.

# 1. prompt userto enter credentials if we can't any saved
# 1a. ask user if they want it saved (to file)
# 2. CRUD subsriptions:
# 2a. when deleting, confirm w user to save them butterfingers
# NCRUSES! (learn to how ncurses first maybe?)
# bonus: hold state of all subscriptions

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
      "secret":   ENV["TWITCH_HMAC_KEY"],
      # "secret": "the ducks are getting hungry",
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
  data = JSON.parse(resp.body).dig?("data")
  if data
    data.as_a.each do |sub|
      stuff_to_show_user = <<-SHOW
        type: #{sub["type"]}
        condition: #{sub["condition"]}
        status: #{sub["status"]}
        id: #{sub["id"]}\n\n
      SHOW

      puts stuff_to_show_user
    end
  end
  # make this print something if theres 0 subscriptions
end

def delete_all_subscriptions
  resp = HTTP::Client.get(
    url: "https://api.twitch.tv/helix/eventsub/subscriptions",
    headers: HEADERS,
  )
  data = JSON.parse(resp.body).dig?("data")
  if data
    data.as_a.each do |sub|
      delete_a_subscription(sub["id"].to_s)
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
    \n\nwhat would you like me to do today? (respond with the corresponding number)
    1. subscribe to follows 
    2. get all subscriptions
    3. delete a subscription  
    4. delete all subscriptions
    5. get me outta here! 
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
    delete_all_subscriptions()
  when "5"
    break
  else
    puts "how'd we get here?"
  end
end
