require "./command.cr"
require "./other_constants.cr"
require "colorize"
require "json"

class Chatty
  getter listening
  @@static_commands = Hash(String, String).new
  self.reload_static_commands

  def self.reload_static_commands : Bool
    @@static_commands.merge! Hash(String, String).from_json(File.read("commands.json"))
    return true
  rescue shit_json : JSON::ParseException
    @@static_commands = Hash(String, String).new
    puts "🤬 shit json"
    return false
  end

  def initialize(token : String,
                 bot_name : String,
                 channel_name : String,
                 knit_between_fibers : Channel(Following_Info))
    @bot_name = bot_name
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
      while listening && (irc_message = @client.gets)
        now = Time.local.to_s("%H:%M")
        if ping?(irc_message)
          answer_ping(irc_message)
        elsif captures = irc_message.match(/^:(?<username>.+)!.+ PRIVMSG #\w+ :(?<message>.+)$/)
          username = captures["username"]
          message = captures["message"]
          respond(username, message)

          # db lookup of username 
          # if no usename => use hashing fn to deterministically get color 
          puts "#{now} #{username}: #{message} ".colorize(:light_magenta)
        else
          puts "#{now} #{irc_message}".colorize(:red)
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

  # array << more_stuff

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
