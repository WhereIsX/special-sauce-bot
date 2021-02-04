require "./secrets.cr"
require "http/client"
require "json"

tw_ex_body = {
  "type":      "channel.follow",
  "version":   "1",
  "condition": {
    "broadcaster_user_id": "12826",
  },
  "transport": {
    "method":   "webhook",
    "callback": "https://example.com/webhooks/callback",
    "secret":   "s3cRe7",
  },
}
z_body = tw_ex_body.to_json

z_head = HTTP::Headers{"Client-ID"     => ENV["TWITCH_APP_ID"],
                       "Authorization" => "Bearer #{ENV["TWITCH_APP_SECRET"]}",
                       "Content-Type"  => "application/json"}

response = HTTP::Client.post(
  url: "https://api.twitch.tv/helix/eventsub/subscriptions",
  headers: z_head,
  body: z_body,
)
p! response.status_code # => 200
p! response.body        # => "<!doctype html>"

# POST https://api.twitch.tv/helix/eventsub/subscriptions
# ----
# Client-ID:     crq72vsaoijkc83xx42hz6i37
# Authorization: Bearer C0BIYxs4JvnBWqvAmBvjfFc
# Content-Type: application/json
# ----
# {
#     "type": "channel.follow",
#     "version": "1",
#     "condition": {
#         "broadcaster_user_id": "12826"
#     },
#     "transport": {
#         "method": "webhook",
#         "callback": "https://example.com/webhooks/callback",
#         "secret": "s3cRe7"
#     }
# }
