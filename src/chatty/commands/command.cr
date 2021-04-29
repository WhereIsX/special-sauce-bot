# GOAL:
# make it so that we can add new commands under their own file
# aka dont want to shove all commands in 1 file

# AND combine static && dynamic commands under this module

# remove from Chatty:
# @@static_commands
# reload_static_commands

require "../irc_message.cr"

class Command
  @@all = Hash(String, Command).new
  getter description

  def initialize(
    @name : String,
    @description : String,
    &@proc : IRCMessage -> String
  )
    @@all[@name] = self
  end

  def call(ircm) : String
    @proc.call(ircm)
  end

  # where_is_x: !feed 10 duckyname
  def self.parse_ircm(ircm) : Tuple(Ducky?, Array(String))
    ducky = Ducky.find_by(username: ircm.username)
    args = ircm.words
    return ducky, args[1..]
  end

  def self.all
    @@all
  end

  def self.is_command?(ircm : IRCMessage) : Bool
    return false if !ircm.is_user_msg?

    command_name = ircm.words.first

    return @@all.has_key?(command_name)
  end

  def self.get_command(ircm : IRCMessage) : Command
    raise "ircm is not a command" if !Command.is_command?(ircm)
    command_name = ircm.words.first
    return @@all[command_name]
  end
end
