# we're no strangers to code,
# you know the rules and so do i.
# a git commit's what i'm thinking of,
# you wouldn't get this from any other lib you tried
require "./src/chatty/chatty.cr"
require "./src/servy/servy.cr"
require "option_parser"

# parse the flags given when program is run
#   $ ./run -s
#   to make bot not respond, and print to terminal only
#   aka a twitch chat client that
silent_mode = false
parser = OptionParser.parse do |parser|
  parser.on(
    flag: "-s",
    description: "silent mode: bot does not respond, only `puts` to terminal"
  ) {
    silent_mode = true
  }
end

alias Following_Info = NamedTuple(broadcaster: String, user: String)

channel = Channel(Following_Info).new(10)

# IRC chat bot
chatty = Chatty.new(
  token: ENV["TWITCH_CHAT_TOKEN"],
  bot_name: ENV["BOT_NAME"],
  channel_name: ENV["CHANNEL_NAME"],
  knit_between_fibers: channel,
  silent_mode: silent_mode,
  use_new_irc_msg: false
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
  else
    chatty.say(yana_says)
  end
end
