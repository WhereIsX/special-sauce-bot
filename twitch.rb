class Twitch
  attr_reader :logger, :running, :socket

  def initialize(project: "")
    @logger  = Logger.new(STDOUT)
    @running = false
    @socket  = nil
  end

  def send_privmsg(message) #stuff
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

        match = line.match(/^:(.+)!.+ PRIVMSG #\w+ :(.+)$/)
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

  def respond(user, message)

    puts message.chomp == "!hey"

    case message.chomp.downcase # NOT fall through: executes on first match && does not continue
    when "!hey"
      logger.info "USER COMMAND: #{user} - !hey"
      send_privmsg "Hay is for horses, #{user}!"

    end
  end

end
