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

# thoughts for sig days
# ctrl + z catchable ?
# sigterm, sigint, sighup (sig hung up), sig kill, ...

# thoughts for bot features
# when duckies use our emotes, we give them points?

charlie = Charlie.new(
  token: TWITCH_TOKEN,
  bot_name: BOT_NAME,
  channel_name: CHANNEL_NAME
)

# charlie.say("talking from the run.cr file")
charlie.listen
Signal::INT.trap { charlie.goodbye; exit }

while charlie.listening && (yana_says = gets)
  yana_says = yana_says.chomp
  if yana_says == "quit"
    charlie.goodbye
  else
    charlie.say(yana_says)
  end
end
