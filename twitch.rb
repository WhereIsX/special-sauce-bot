require_relative 'gif'
require_relative 'mods'

class Twitch
  attr_reader :logger, :running, :socket, :gif_buffer

  def initialize(project: "")
    @logger  = Logger.new(STDOUT)
    @running = false
    @socket  = nil
    @project = project
    @gif_buffer = {}
    @all_gifs = ALL_GIFS
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

    puts message.chomp == "!hey"

    case message.chomp.downcase
      # NOT fall through: executes on first match && does not continue
    when "!hey"
      logger.info "USER COMMAND: #{user} - !hey"
      send_privmsg "Hay is for horses, #{user}!"

    when "!project"
      send_privmsg @project


    when /^!addgif/ # !addgif [name] [link] [garbage]
      # prevent this command from being spammed
      if @gif_buffer.size <= 3

        gif = message.split(" ")
        name = gif[1]
        link = gif[2]
        # ToNewExperiences suggest defer to mods

        # validations for proper name && isnt already being used in buffer + all_gifs
        if  !@gif_buffer.key?(name) &&
            !@all_gifs.key?(name)   &&
            name.length <= 10

          @gif_buffer[name] = link
          send_privmsg "got #{name} - #{link}"
        end
      end


    when /^!yesgif/ # !yesgif [name]
      # assume that [name] does not collide with current @all_gifs
      name = message.split(" ")[1]
      link = @gif_buffer[name]

      if MODS.include?(user) && @gif_buffer.key?(name)
        @all_gifs[name] = @gif_buffer[name]
        send_privmsg "#{name} - #{link} was approved ^-^"
        # File.open('gif')
        # File.
      end

    when /^!nogif/ #

    when /^!giflist/ # display array
      send_privmsg "#{@gif_buffer}"

    when "!amimod"
      send_privmsg "#{MODS.include? user}"

    when /!vote/

    when /sounds/
      send_privmsg "wanna make sounds hoppen? watch an ad for 10 bits"

    when "!giforgif"
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
      # points system for awesome viewrs who use points for yana goodness, i.e., hydrate, posture check, etc.


    end
  end

end
