# originally from https://gist.github.com/nevern02/98bdc9701e2741f4cb3b0b47f3d2c429
 
# A quick example of a Twitch chat bot in Ruby.
# No third party libraries. Just Ruby standard lib.
#
# See the tutorial video: https://www.youtube.com/watch?v=_FbRcZNdNjQ
#

# You can fill in creds here or use environment variables if you choose.


## TODO:
# => gif name not already in all_gifs
# => more words to search for using regex
# => capitalization of user names, maybe we can use twitch api instead of twitch irc
# => NLP? **

require 'socket'
require 'logger'
require 'pry'
require_relative 'twitch'

TWITCH_CHAT_TOKEN = ENV['TWITCH_CHAT_TOKEN']
TWITCH_USER       = ENV['TWITCH_USER']

Thread.abort_on_exception = true

# credentials check
if TWITCH_CHAT_TOKEN.nil? ||
  TWITCH_USER.nil?
  puts "You need to fill in your own Twitch credentials!"
  exit(1)
end

bot = Twitch.new()
bot.run

while (bot.running) do
  command = gets.chomp

  if command == 'quit'
    bot.stop
  else
    bot.send_privmsg(command)
  end
end

puts 'Exited'
