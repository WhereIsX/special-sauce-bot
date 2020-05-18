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
    socket.puts("JOIN ##{TWITCH_USER}")
    logger.info 'Connected...'

    Thread.start do
      while (running) do
        ready = IO.select([socket])

        ready[0].each do |s|
          line    = s.gets
          match   = line.match(/^:(.+)!(.+) PRIVMSG #(\w+) :(.+)$/)

          message = match && match[4]

          # NLP ?
          # database => points system for stuff
          # code in the chat :D `.eval`
          # transpiler (code from gist/pastebin/etc => ruby)
            # how to recognize language? << HARD
            # we're making the google translate of code << use external library
          # assistant -- request time to pair / do things with yana
          #   => time is available, not available, etc.
          # assistant -- prioritize urgency
          #   =>

          case
          when /^!hey/
            user = match[1]
            logger.info "USER COMMAND: #{user} - !hey"
            send "PRIVMSG ##{TWITCH_USER} :Hay is for horses, #{user}!"

          when /discord/
            send "PRIVMSG ##{TWITCH_USER} :someone said discord?"
          end



            # "I like chicken"
            # subject.verb(object, parameter1, ...)
            # chicken = Chicken.new
            # where_is_x.like(chicken)

            # !editor
            #

            # !uptime
            # => (streaming time) / (total time since first stream)
            #


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

# binding.pry

# credentials check
if TWITCH_CHAT_TOKEN.nil? ||
  TWITCH_USER.nil?
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
