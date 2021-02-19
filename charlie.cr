require "./command.cr"
require "./other_constants.cr"

class Charlie
  getter listening

  def initialize(token : String, bot_name : String, channel_name : String, knit_between_fibers : Channel(Following_Info))
    @channel_name = channel_name
    @knit_between_fibers = knit_between_fibers
    tcp_sock = TCPSocket.new("irc.chat.twitch.tv", 6697)
    @client = OpenSSL::SSL::Socket::Client.new(tcp_sock)

    @client.puts("PASS #{token}")
    @client.puts("NICK #{bot_name}") # twitch doesn't seem to use this...
    @client.puts("JOIN ##{channel_name}")
    puts "I'm alive!"
    say("🌊 hi")
  end

  def say(message : String)
    @client.puts("PRIVMSG ##{@channel_name} :#{message} \r\n")
    @client.flush
  end

  def listen
    @listening = true
    spawn do
      while listening && (line = @client.gets)
        puts line
        if ping?(line)
          answer_ping(line)
        else
          captures = line.match(/^:(?<username>.+)!.+ PRIVMSG #\w+ :(?<message>.+)$/)
          respond(captures["username"], captures["message"]) if captures
        end
      end
    end

    spawn do
      while listening && (following_event = @knit_between_fibers.receive)
        say("Waaat thanks for quackin' along #{following_event[:user]} Waaat")
      end
    end
  end

  def respond(username : String, message : String)
    message_array = message.split(' ')
    command = message_array.shift
    argument = message_array.join(' ')

    if weturn = COMMAND_VOCABULARY[command]? # weturn => return => naming things is hard
      say(weturn.call(argument))
    end
  end

  def goodbye
    say("🌊 bye")
    # part the channel
    # quit the server
    @client.puts("QUIT")
    @listening = false
    # puts @client.gets

    @client.close
    puts "\n🌊\n"
  end

  def ping?(line)
    return line == "PING :tmi.twitch.tv"
  end

  def answer_ping(line : String)
    say PONG_FACTS[Random.rand(PONG_FACTS.size)] # "PONG" :>
  end
end
