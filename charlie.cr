class Charlie
  def initialize(token : String, bot_name : String, channel_name : String)
    tcp_sock = TCPSocket.new("irc.chat.twitch.tv", 6697)
    @client = OpenSSL::SSL::Socket::Client.new(tcp_sock)

    @channel_name = channel_name
    @client.puts("PASS #{token}")
    @client.puts("NICK #{bot_name}")
    @client.puts("JOIN ##{channel_name}")
    puts "Connecting... "
    say("The awesomeness has arrived, make way!")
    @client.flush
    sleep 10
    say("oh")
  end

  def say(message : String)
    p message
    @client.puts("PRIVMSG ##{@channel_name} :#{message} \r\n")
  end

  # A: hello
  # B: yo

  def listen
    # spawn do
    say("starting to listen")
    3.times do
      words = @client.gets
      say("we heard that:  #{words}")
      sleep(15)
    end
    # end
  end

  def goodbye
    @client.flush
    @client.close
  end
end
