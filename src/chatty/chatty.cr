require "./**" # import everything including dir inside ourselves :>
require "./../data/constants_collection.cr"
require "./../models/ducky.cr"
require "./../models/leak.cr"
require "./../models/yak.cr"
require "json"

class Chatty
  getter listening

  def initialize(token : String,
                 bot_name : String,
                 channel_name : String,
                 knit_between_fibers : Channel(Following_Info),
                 silent_mode : Bool = false,
                 use_new_irc_msg : Bool = false)
    @bot_name = bot_name
    @channel_name = channel_name
    @knit_between_fibers = knit_between_fibers
    tcp_sock = TCPSocket.new("irc.chat.twitch.tv", 6697)
    @client = OpenSSL::SSL::Socket::Client.new(tcp_sock)
    @silent_mode = silent_mode
    @use_new_irc_msg = use_new_irc_msg

    @client.puts("PASS #{token}")
    @client.puts("NICK #{bot_name}") # twitch doesn't seem to use this ???
    @client.puts("JOIN ##{channel_name}")
    @client.puts("CAP REQ :twitch.tv/tags") # gimme them tags booboo

    Command.all["!reload"].call(IRCMessage.new(""))
    puts "I'm alive!"
    say("🌊 hi")
  end

  # def say(message : String)
  #   if message.size > 500
  #     puts "⚠️ MESSAGE TOO THICC"
  #   end
  #   @client.puts("PRIVMSG ##{@channel_name} :#{message} \r\n")
  #   @client.flush
  # end

  def say(message : String)
    if message.size > 500
      puts "⚠️ MESSAGE TOO THICC"
      words = message.split(' ')
      halfway = words.size // 2
      first_part = words[0...halfway].join(' ')
      second_part = words[halfway..].join(' ')
      @client.puts("PRIVMSG ##{@channel_name} :#{first_part} \r\n")
      @client.puts("PRIVMSG ##{@channel_name} :#{second_part} \r\n")
      @client.flush
    end
    @client.puts("PRIVMSG ##{@channel_name} :#{message} \r\n")
    @client.flush
  end

  def listen
    @listening = true
    spawn do
      while listening && (raw_irc = @client.gets)
        time = Time.local(Time::Location.load("America/New_York"))
        ircm = IRCMessage.new(raw_irc)
        # log all chatter by writing to a file
        log(time, ircm)
        # print message to terminal
        puts ircm.pretty_print

        if ircm.is_ping?
          answer_ping()
        elsif ircm.is_user_msg?
          if should_respond_to_message?(ircm.username, ircm.message)
            respond(ircm)
          end
        end
      end
    end

    # fiber stuff for follows
    spawn do
      while listening && (following_event = @knit_between_fibers.receive)
        say("Waaat thanks for quackin' along #{following_event[:user]} Waaat")
      end
    end
  end

  def log(time : Time, msg : IRCMessage)
    File.open(filename: time.to_s("%Y-%m-%d"), mode: "a") do |f|
      f.puts msg.log
    end
  end

  def should_respond_to_message?(username : String, message : String)
    # silent mode == don't say anything to chat
    # also no more bot fights
    return !@silent_mode && username && message && username != @bot_name
  end

  def respond(ircm)
    if Command.is_command?(ircm)
      say Command.get_command(ircm).call(ircm)
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

  def answer_ping
    if @silent_mode
      @client.puts "PONG :tmi.twitch.tv \r\n"
      @client.flush
      # say "have you joined the flock yet? !start_record so we can start feeding you peas :>"
    else
      say PONG_FACTS[Random.rand(PONG_FACTS.size)] # "PONG" :>
    end
  end
end
