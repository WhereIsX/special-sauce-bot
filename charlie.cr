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

  # A: hello
  # B: yo

  def listen
    @listening = true
    spawn do
      while listening && (line = @client.gets)
        puts line
        # TODO named captured groups
        match = line.match(/^:(.+)!.+ PRIVMSG #\w+ :(.+)$/)

        # do some stuff in response to messages
        if match
          user = match[1]
          message = match[2]
        end
      end
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
end
