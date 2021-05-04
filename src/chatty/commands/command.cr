# GOAL:
# make it so that we can add new commands under their own file
# aka dont want to shove all commands in 1 file

# AND combine static && dynamic commands under this module

# remove from Chatty:
# @@static_commands
# reload_static_commands
# if enough duckies type:
# !mute <username>
# within a time period,
# bot will automute(?)

require "../irc_message.cr"

class Command
  @@static = Array(String).new
  @@all = Hash(String, Command).new
  getter name, description

  enum Update
    Revoke
    Give
  end

  def initialize(
    @name : String,
    @description : String,
    &@proc : IRCMessage -> String
  )
    if @name.empty?
      raise ArgumentError.new("name is undefined")
    end

    @@all[@name] = self
  end

  def call(ircm : IRCMessage) : String
    @proc.call(ircm)
  end

  def self.parse_ircm(ircm : IRCMessage) : Tuple(Model::Ducky?, Array(String))
    ducky = Model::Ducky.find_by(username: ircm.username)
    args = ircm.words
    return ducky, args[1..]
  end

  def self.all : Hash(String, Command)
    @@all
  end

  def self.static : Array(String)
    @@static
  end

  def self.static=(new_static : Array(String))
    @@static = new_static
  end

  def self.is_command?(ircm : IRCMessage) : Bool
    return false if !ircm.is_user_msg?

    command_name = ircm.words.first

    return @@all.has_key?(command_name)
  end

  def self.get_command(ircm : IRCMessage) : Command
    raise ArgumentError.new("#{ircm} is not a command") if !Command.is_command?(ircm)
    command_name = ircm.words.first
    return @@all[command_name]
  end
end
