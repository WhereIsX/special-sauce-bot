require "./*"
require "./../data/other_constants.cr"
require "./../models/ducky.cr"
require "./../models/leak.cr"
require "./../models/yak.cr"
require "json"

class Chatty
  getter listening
  @@static_commands = Hash(String, String).new
  self.reload_static_commands

  def self.reload_static_commands : Bool
    @@static_commands.merge! Hash(String, String).from_json(File.read("./src/data/commands.json"))
    return true
  rescue shit_json : JSON::ParseException
    @@static_commands = Hash(String, String).new
    puts "🤬 shit json"
    return false
  rescue shit_path : File::NotFoundError
    puts "🤬 shit path \n#{p! `pwd`}"
    return false
  end

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
      while listening && (raw_irc = @client.gets)
        now = Time.local.to_s
        ircm = IRCMessage.new(raw_irc)
        if ircm.type == IRCMessage::MessageType::Ping
          answer_ping()
        elsif ircm.type == IRCMessage::MessageType::UserMessage
          if ircm.username && ircm.message && !@silent_mode
            # respond to the message accordingly unless chatter is another instance
            # no more bot fights
            respond(ircm.username, ircm.message) unless ircm.username == @bot_name
          end
        end
        puts ircm.print
      end
    end

    # fiber stuff for follows
    spawn do
      while listening && (following_event = @knit_between_fibers.receive)
        say("Waaat thanks for quackin' along #{following_event[:user]} Waaat")
      end
    end
  end

  # temporarily
  def respond(username : String, message : String)
    message_array = message.split(' ')
    command = message_array.shift
    argument = message_array.join(' ')
    if command == "!reload" && SUPER_COWS.includes?(username)
      if Chatty.reload_static_commands
        say("you got it bawhs")
      else # reload failed
        say("theres probably some trailing comma in the shit json, ya wat")
      end
    elsif weturn = DYNAMIC_COMMANDS[command]? # weturn => return => naming things is hard
      say(weturn.call(username, argument))
    elsif @@static_commands.has_key?(command)
      say(@@static_commands[command])
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
    say PONG_FACTS[Random.rand(PONG_FACTS.size)] # "PONG" :>
  end
end
