class IRCMessage
  getter type

  enum MessageType
    Ping
    UserMessage
    Twitch
  end

  def initialize(raw_message : String)
    # parse what what type this IRC message is
    @type : MessageType
    # then parse it further if is user message
  end

  def self.parse(raw_irc : String) : NamedTuple(
    sender: String,
    message: String,
    tags: Hash(String, String),
  )
    username = ""
    message = ""

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
      # shouldn't hit this line bc
    end
    return {tags: tags, username: username, message: message}
  end

  private def parse_raw_channel_chatter(raw_irc : String) : NamedTuple(
    tags: Hash(String, String),
    username: String,
    message: String)
  end

  def print(colorized = true) : String
    # assemble a string ready for printing to terminal
  end
end
