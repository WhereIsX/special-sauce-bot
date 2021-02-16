require "./charlie.cr"
require "./bobbie.cr"
require "socket"
require "openssl"

charlie = Charlie.new(
  token: ENV["TWITCH_CHAT_TOKEN"],
  bot_name: ENV["BOT_NAME"],
  channel_name: ENV["CHANNEL_NAME"],
)

charlie.listen

bobbie = Bobbie.new

bobbie.listen

Signal::INT.trap { charlie.goodbye; exit }
# bobbie.goodbye please

while charlie.listening && (yana_says = gets)
  yana_says = yana_says.chomp
  if yana_says == "quit"
    charlie.goodbye
  else
    charlie.say(yana_says)
  end
end
