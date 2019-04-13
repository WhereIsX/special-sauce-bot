# A quick example of a Twitch chat bot in Ruby.
# No third party libraries. Just Ruby standard lib.
#
# See the tutorial video: https://www.youtube.com/watch?v=_FbRcZNdNjQ
#

# You can fill in creds here or use environment variables if you choose.
TWITCH_CHAT_TOKEN = ENV['TWITCH_CHAT_TOKEN']
TWITCH_USER       = ENV['TWITCH_USER']

require 'socket'
require 'logger'

Thread.abort_on_exception = true

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

  def run
    logger.info 'Preparing to connect...'

    @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
    @running = true

    socket.puts("PASS #{TWITCH_CHAT_TOKEN}")
    socket.puts("NICK #{TWITCH_USER}")

    logger.info 'Connected...'

    Thread.start do
      while (running) do
        ready = IO.select([socket])

        ready[0].each do |s|
          line    = s.gets
          match   = line.match(/^:(.+)!(.+) PRIVMSG #(\w+) :(.+)$/)
          message = match && match[4]

          if message =~ /^!hello/
            user = match[1]
            logger.info "USER COMMAND: #{user} - !hello"
            send "PRIVMSG #open_mailbox :Hello, #{user} from Mailbot!"
          end

          logger.info "> #{line}"
        end
      end
    end
  end

  def stop
    @running = false
  end
end

if TWITCH_CHAT_TOKEN.empty || TWITCH_USER.empty?
  puts "You need to fill in your own Twitch credentials!"
  exit(1)
end

bot = Twitch.new
bot.run

while (bot.running) do
  command = gets.chomp

  if command == 'quit'
    bot.stop
  else
    bot.send(command)
  end
end

puts 'Exited.'