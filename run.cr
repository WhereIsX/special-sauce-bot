require "./charlie.cr"
require "./secrets.cr"
require "socket"
require "openssl"
# ^ make issue/PR to Crystal about
# 1: examples
# 2?: how children can point to parents for examples

# questions for sock day
# how can I make sure these socks are encrypted with ssl?
# why do they still call this ssl when its clearly *deprecated*
# wtf is client.puts really doing?
# read through original IRC RFC doc: https://tools.ietf.org/html/rfc1459
# what happens when a socket isn't closed!?

# thoughts for bot features
# when duckies use our emotes, we give them points?

charlie = Charlie.new(
  token: TWITCH_TOKEN,
  bot_name: BOT_NAME,
  channel_name: CHANNEL_NAME
)
# loop for charlies behaviors
# charlie.say("testing")
# and if we type "bye" into terminal => charlie.goodbye
