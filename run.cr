require "./dblibrarian.cr"
require "./chatty.cr"
require "./servy.cr"
require "socket"
require "openssl"

alias Following_Info = NamedTuple(broadcaster: String, user: String)
# alias TwitchEvent = NamedTuple(event_type: String, broadcaster: String, user: String)

channel = Channel(Following_Info).new(10)

# IRC chat bot
chatty = Chatty.new(
  token: ENV["TWITCH_CHAT_TOKEN"],
  bot_name: ENV["BOT_NAME"],
  channel_name: ENV["CHANNEL_NAME"],
  knit_between_fibers: channel,
)

chatty.listen

# HTTP server
#   (endpoint for twitch eventsub)
servy = Servy.new(
  knit_between_fibers: channel
)

servy.listen

Signal::INT.trap { chatty.goodbye; exit }

while chatty.listening && (yana_says = gets)
  yana_says = yana_says.chomp
  if yana_says == "quit"
    # Process.signal(signal: Signal::INT, pid: 0)
    chatty.goodbye
    servy.goodbye
    Commands::LIBRARIAN.goodbye
  else
    chatty.say(yana_says)
  end
end
