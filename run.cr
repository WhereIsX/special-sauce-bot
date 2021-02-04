require "./charlie.cr"
require "socket"
require "openssl"

charlie = Charlie.new(
  token: ENV["TWITCH_TOKEN"],
  bot_name: ENV["BOT_NAME"],
  channel_name: ENV["CHANNEL_NAME"],
)

charlie.serve

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
