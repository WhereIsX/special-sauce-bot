require "./command.cr"

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

  def say(message : String)
    @client.puts("PRIVMSG ##{@channel_name} :#{message} \r\n")
    @client.flush
  end

  # Alice: !echo Im so pretty 
  # where_is_x_bot: I'm so pretty 



  def listen
    @listening = true
    spawn do
      while listening && (line = @client.gets)
        puts line
        if ping?(line)
          handle_ping(line)
        else 
          match= line.match(/^:(.+)!.+ PRIVMSG #\w+ :(.+)$/)
          handle_message(match) if match 
      end
    end
  end

  def handle_message(match)
    user = match[1]
    message = match[2]

    # message => "!echo stuff" 
    # split into command and then "stuff"

    if COMMAND_VOCABULARY[message]?
      say(COMMAND_VOCABULARY[message])
    else 
      
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

  private 

  def ping?(line)
    return line == "PING :tmi.twitch.tv"
  end 

  def handle_ping(line : String)
    say PONG_FACTS[Random.rand(PONG_FACTS.size)] # "PONG" :>
  end 
end
