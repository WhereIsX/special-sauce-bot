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
                 knit_between_fibers : Channel(Following_Info))
    @bot_name = bot_name
    @channel_name = channel_name
    @knit_between_fibers = knit_between_fibers
    tcp_sock = TCPSocket.new("irc.chat.twitch.tv", 6697)
    @client = OpenSSL::SSL::Socket::Client.new(tcp_sock)

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
        now = Time.local.to_s("%H:%M")
        if ping?(raw_irc)
          answer_ping(raw_irc)
        elsif is_user_message?(raw_irc)
          stuff = parse_raw_channel_chatter(raw_irc)
          tags, username, message = stuff[:tags], stuff[:username], stuff[:message]
          if username && message
            respond(username, message) unless username == @bot_name
          end
          if tags.has_key?("color")
            print "#{now} #{username}: ".colorize(Colors.from_hex(tags["color"]))
            puts message # 6 spaces preceding message to inline with time
          else
            print "#{now} #{username}: ".colorize(Colors.from_username(username))
            puts message
          end
        else
          puts "#{now} #{raw_irc}\n".colorize(:red)
        end
      end
    end

    spawn do
      while listening && (following_event = @knit_between_fibers.receive)
        say("Waaat thanks for quackin' along #{following_event[:user]} Waaat")
      end
    end
  end

  private def parse_raw_channel_chatter(raw_irc : String) : NamedTuple(
    tags: Hash(String, String),
    username: String,
    message: String)
    raw_tags, rest = raw_irc.split(separator: ' ', limit: 2)
    tags = Hash(String, String).new

    raw_tags.split(';').each do |tag|
      parsed_tag = tag.split('=')
      next if parsed_tag.size != 2 || parsed_tag.last.empty?
      # we can asume that we have a nonempty parsed tag
      tag_name = parsed_tag.first
      tag_value = parsed_tag.last
      tags[tag_name] = tag_value
    end
    captures = rest.match(/^:(?<username>.+)!.+ PRIVMSG #\w+ :(?<message>.+)$/)
    if captures
      username = captures["username"]
      message = captures["message"]
    else
      username = ""
      message = ""
    end
    return {tags: tags, username: username, message: message}
  end

  def is_user_message?(raw_irc)
    return raw_irc.includes? "PRIVMSG"
  end

  private def rbg_messages(username : String, message : String)

    # a duckys color could be:
    # - set by them on our db
    # - set by them on twitch (tag)
    # - determined by .hash
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
