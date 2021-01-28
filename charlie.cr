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

  def listen
    @listening = true
    spawn do
      while listening && (line = @client.gets)
        puts line
        if line == "PING :tmi.twitch.tv"
          say("oh hello thar")
        end
        match = line.match(/^:(.+)!.+ PRIVMSG #\w+ :(.+)$/)

        if match
          user = match[1]
          message = match[2]

          if COMMAND_VOCABULARY[message]?
            say(COMMAND_VOCABULARY[message])
          end
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
