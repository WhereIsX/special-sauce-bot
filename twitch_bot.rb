# A quick example of a Twitch chat bot in Ruby.
# No third party libraries. Just Ruby standard lib.
#
# See the tutorial video: https://www.youtube.com/watch?v=_FbRcZNdNjQ
#

# You can fill in creds here or use environment variables if you choose.


## TODO:
# => more words to search for using regex
# => capitalization of user names, maybe we can use twitch api instead of twitch irc
# => NLP? **

require 'socket'
require 'logger'
require_relative 'gif'

TWITCH_CHAT_TOKEN = ENV['TWITCH_CHAT_TOKEN']
TWITCH_USER       = ENV['TWITCH_USER']


Thread.abort_on_exception = true



class Twitch
  attr_reader :logger, :running, :socket, :gif_buffer

  def initialize(project: "")
    @logger  = Logger.new(STDOUT)
    @running = false
    @socket  = nil
    @project = project
    @gif_buffer = []
  end

  def send_privmsg(message)
    send("PRIVMSG ##{TWITCH_USER} :#{message}")
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
      while running && line = socket.gets

        match   = line.match(/^:(.+)!.+ PRIVMSG #\w+ :(.+)$/)
        next if match.nil?

        user = match[1]
        message = match[2]

        respond(user, message)

        logger.info "> #{line}"
      end
    end
  end


  def stop
    @running = false
  end


  private

  # respond to a message when its pertinent (matches regexp)
  # sometimes calls send
  def respond(user, message)

    p "message is: #{message}"
    p message.class
    puts message.chomp == "!hey"

    case message.chomp.downcase
      # NOT fall through: executes on first match && does not continue
    when "!hey"
      logger.info "USER COMMAND: #{user} - !hey"
      send_privmsg "Hay is for horses, #{user}!"

    when "!project"
      send_privmsg @project


    # when /^!addgif/
    #   # prevent this command from being spammed
    #   next if @gif_buffer.size > 3
    #
    #   link = message.split(" ")[1]
    #   @gif_buffer << link
    #   puts "accept the link? \n0 to deny\n1 to accept\n"
    #   decision = gets.chomp.to_i
    #   case decision
    #   when 0


      # someone can add dick pics
      # make a temporary list of gifs to be approved
      # once approved -> add to gifs array

    when /gif/
      send_privmsg "https://www.youtube.com/watch?v=A-Rm1DsV7GM"

    when /discord/
      send_privmsg "join the best discord https://discord.gg/kjxcb9J"

    when /recurse/
      send_privmsg <<~DOC
      the recruse center is a self-directed educational retreat for programmers: recurse.com
      DOC

    when /duck/
      send_privmsg GIF_DUCKIES.sample

    when /disconnected from discord/
    when /pair/
      send_privmsg ""

    when /more schtuff/
      #incorporate some NLP!
      # look up in a databse


    end
  end

end

# credentials check
if TWITCH_CHAT_TOKEN.nil? ||
  TWITCH_USER.nil?
  puts "You need to fill in your own Twitch credentials!"
  exit(1)
end

project_file = File.open("project.txt")
project = project_file.read
project_file.close

bot = Twitch.new(project: project)
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
