require "chat_colors.cr"

class IRCMessage
  getter type

  enum MessageType
    Ping
    UserMessage
    TwitchMessage
  end

  alias ParsedUserMessage = NamedTuple(
    username: String,
    message: String,
    tags: Hash(String, String),
  )

  def initialize(@raw_irc : String)
    # parse what what type this IRC message is
    @type : MessageType | Nil = parse_type()

    # then parse it further if is user message
    @parsed_user_message : ParsedUserMessage | Nil = parse()
  end

  # TODO: rename username => sender
  # parse_user_message?
  def parse : ParsedUserMessage | Nil
    raw_tags, rest = @raw_irc.split(separator: ' ', limit: 2)
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

  # private def parse_raw_channel_chatter(raw_irc : String) : NamedTuple(
  #   tags: Hash(String, String),
  #   username: String,
  #   message: String)
  # end

  def parse_type : MessageType | Nil
    if ping?
      return MessageType::Ping
    elsif user_message?
      return MessageType::UserMessage
    elsif twitch_message?
      return MessageType::TwitchMessage
    end
    return Nil
  end

  def ping? : Bool
    # pray to the twitch gods they dont change their ping string
    return @raw_irc.starts_with?("PING")
  end

  def user_message? : Bool
    # return @raw_irc.starts_with?("@badge-info")
    return @raw_irc.includes?("PRIVMSG")
  end

  def twitch_message?
    return @raw_irc.starts_with?(":tmi.twitch.tv")
  end

  # WIP HERE!
  def print
    # assemble a string ready for printing to terminal

    #  # if user set a color on twitch
    if tags.has_key?("color")
      print "#{now} #{username}: ".colorize(Colors.from_hex(tags["color"]))
      puts message # 6 spaces preceding message to inline with time
      # if user doesn't have a color, we deterministically hash them one :>
    else
      print "#{now} #{username}: ".colorize(Colors.from_username(username))
      puts message
    end

    case @type
    when MessageType::Ping
      return
    when MessageType::UserMessage
      return
    when MessageType::TwitchMessage
      return @raw_irc.colorize(:light_magenta)
    end
    return "💔 wtf is this? \n#{@raw_irc}".colorize(:red)
  end
end
