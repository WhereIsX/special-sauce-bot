require "./chat_colors.cr"
require "../models/ducky.cr"

class IRCMessage
  getter(type, time, username, message, raw_irc, words, ducky)

  @raw_irc : String
  @time : Time
  @type : MessageType | Nil
  @tags : Hash(String, String)
  @username : String
  @message : String
  @words : Array(String)
  @ducky : Model::Ducky | Nil

  enum MessageType
    TwitchMessage
    Ping
    UserMessage
  end

  def initialize(@raw_irc : String)
    # default values
    @time = Time.local(Time::Location.load("America/New_York"))
    @type = parse_type()
    @username = ""
    @message = @raw_irc
    @words = Array(String).new
    @tags = Hash(String, String).new
    @ducky = nil

    # then parse it further if is user message
    if @type == MessageType::UserMessage
      parsed_ircm = parse()
      @tags = parsed_ircm[:tags]
      @username = parsed_ircm[:username]
      @message = parsed_ircm[:message]
      @words = @message.split(' ', remove_empty: true)
      @ducky = Model::Ducky.find_by(username: @username)
      # give ducky peas if its a ducky chatting
      give_peas_for_chatting()
    end
  end

  # TODO: rename username => sender
  # parse_user_message?
  private def parse : NamedTuple(
    username: String,
    message: String,
    tags: Hash(String, String),
  )
    raw_tags, rest = @raw_irc.split(separator: ' ', limit: 2)
    tags = Hash(String, String).new

    # populate the tags hash
    raw_tags.split(';').each do |tag|
      parsed_tag = tag.split('=')
      next if parsed_tag.size != 2 || parsed_tag.last.empty?
      # we can asume that we have a nonempty parsed tag
      tag_name = parsed_tag.first
      tag_value = parsed_tag.last
      tags[tag_name] = tag_value
    end

    # get the username and message
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

  private def give_peas_for_chatting
    ducky = @ducky
    return if ducky.nil?
    ducky.points += 1
    if !ducky.save
      puts "⚠️ you wat"
    end
  end

  private def parse_type : MessageType | Nil
    if ping?
      return MessageType::Ping
    elsif user_message?
      return MessageType::UserMessage
    elsif twitch_message?
      return MessageType::TwitchMessage
    end
    return nil
  end

  private def ping? : Bool
    # pray to the twitch gods they dont change their ping string
    return @raw_irc.starts_with?("PING")
  end

  private def user_message? : Bool
    # return @raw_irc.starts_with?("@badge-info")
    return @raw_irc.includes?("PRIVMSG")
  end

  private def twitch_message? : Bool
    return @raw_irc.starts_with?(":tmi.twitch.tv")
  end

  def is_ping? : Bool
    @type == MessageType::Ping
  end

  def is_user_msg? : Bool
    @type == MessageType::UserMessage
  end

  def log : String
    return "#{@time.to_s("%H:%M")} #{@username} : #{@message}"
  end

  def pretty_print : String
    # assemble a string ready for printing to terminal
    case @type
    when MessageType::TwitchMessage
      return "🔧 #{@raw_irc}".colorize(:light_magenta).to_s
    when MessageType::Ping
      return "🏓 #{@raw_irc}".colorize(:cyan).to_s
    when MessageType::UserMessage
      if @tags.nil?
        return "wat".colorize(:red).to_s
      end

      if @tags.has_key?("color")
        # if user set a color on twitch
        header = "#{@time.to_s("%H:%M")} 🎨#{@username}: ".colorize(Colors.from_hex(@tags["color"]))
        return header.to_s + message
      else
        # if user doesn't have a color, we deterministically hash them one :>
        header = "#{@time.to_s("%H:%M")} ️️️❔#{@username}: ".colorize(Colors.from_username(username))
        return header.to_s + message
      end
    end
    return "💔 wtf is this!? \n#{@raw_irc}".colorize(:red).to_s
    # return @raw_irc.colorize(:red).to_s
  end
end
