class Charlie
  def initialize(token : String, bot_name : String, channel_name : String)
    tcp_sock = TCPSocket.new("irc.chat.twitch.tv", 6697)
    @client = OpenSSL::SSL::Socket::Client.new(tcp_sock)

    @channel_name = channel_name
    @client.puts("PASS #{token}")
    @client.puts("NICK #{bot_name}")
    @client.puts("JOIN ##{channel_name}")
    puts "Connecting... "
  end

  def say(message : String)
    @client.puts("PRIVMSG ##{@channel_name} :#{message}")
  end

  def goodbye
    @client.close
  end
end
