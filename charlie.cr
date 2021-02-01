require "./command.cr"
require "./other_constants.cr"

class Charlie
  getter listening

  def initialize(token : String, bot_name : String, channel_name : String)
    tcp_sock = TCPSocket.new("irc.chat.twitch.tv", 6697)
    @channel_name = channel_name
    @client = OpenSSL::SSL::Socket::Client.new(tcp_sock)

    @client.puts("PASS #{token}")
    @client.puts("NICK #{bot_name}")
    @client.puts("JOIN ##{channel_name}")
    puts "I'm alive!"
    say("🌊 hi")
  end

  # deal with this!
  def say(message : String)
    @client.puts("PRIVMSG ##{@channel_name} :#{message} \r\n")
    @client.flush
  end

  def serve
    # start up the server
    # start up ngrok
    # figure out where our ngrok endpoint is
    # pass it to twitch
    #
  end

  # Alice: !echo Im so pretty
  # where_is_x_bot: I'm so pretty

  def listen
    @listening = true
    spawn do
      while listening && (line = @client.gets)
        puts line
        if ping?(line)
          answer_ping(line)
        else
          match = line.match(/^:(.+)!.+ PRIVMSG #\w+ :(.+)$/)
          respond(match) if match
        end
      end
    end
  end

  def respond(match)
    user = match[1]
    stuff = match[2].split(' ')
    command = stuff.shift
    stuff = stuff.join(' ')

    if weturn = COMMAND_VOCABULARY[command]? # weturn => return => naming things is hard
      say(weturn.call(stuff))
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
