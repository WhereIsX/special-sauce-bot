# derived from https://gist.github.com/nevern02/98bdc9701e2741f4cb3b0b47f3d2c429


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
