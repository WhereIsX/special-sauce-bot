# A quick example of a Twitch chat bot in Ruby.
# No third party libraries. Just Ruby standard lib.
#
# See the tutorial video: https://www.youtube.com/watch?v=_FbRcZNdNjQ
#

# You can fill in creds here or use environment variables if you choose.
require 'pry'
TWITCH_CHAT_TOKEN = ENV['TWITCH_CHAT_TOKEN']
TWITCH_USER       = ENV['TWITCH_USER']

require 'socket'
require 'logger'

Thread.abort_on_exception = true
class ChatBot


end

class Twitch
  attr_reader :logger, :running, :socket

  def initialize(logger = nil)
    @logger  = logger || Logger.new(STDOUT)
    @running = false
    @socket  = nil
  end

  def send(message)
    logger.info "< #{message}"
    socket.puts(message)
  end

  def run(project="")
    logger.info 'Preparing to connect...'

    @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
    @running = true

    socket.puts("PASS #{TWITCH_CHAT_TOKEN}")
    socket.puts("NICK #{TWITCH_USER}")
    socket.puts("JOIN ##{TWITCH_USER}")
    logger.info 'Connected...'

    Thread.start do
      while running && line = socket.gets

        match   = line.match(/^:(.+)!.+ PRIVMSG #\w+ :(.+)$/)
        next if match.nil?

        user = match[1]
        message = match[2]

        case message
        when /^!hey/
          logger.info "USER COMMAND: #{user} - !hey"
          send "PRIVMSG ##{TWITCH_USER} :Hay is for horses, #{user}!"

        when /discord/
          send "PRIVMSG ##{TWITCH_USER} :join the best discord https://discord.gg/kV2MsYz"


        when /project/
          send "PRIVMSG ##{TWITCH_USER} :#{project}"

        when /pair/

        end

        logger.info "> #{line}"

      end
    end
  end


  def stop
    @running = false
  end
end

# binding.pry

# credentials check
if TWITCH_CHAT_TOKEN.nil? ||
  TWITCH_USER.nil?
  puts "You need to fill in your own Twitch credentials!"
  exit(1)
end

bot = Twitch.new
puts 'which project are we working on today? (chatbots response to project)'
project = gets.chomp
bot.run(project)

while (bot.running) do
  command = gets.chomp

  if command == 'quit'
    bot.stop
  else
    bot.send("PRIVMSG ##{TWITCH_USER} :#{command}")
  end
end

puts 'Exited.'
