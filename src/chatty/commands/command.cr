# remove from Chatty:
# @@static_commands
# reload_static_commands
# if enough duckies species:
# !mute <username>
# within a time period,
# bot will automute(?)

require "../irc_message.cr"

class Command
  @@static = Hash(String, Command).new
  @@dynamic = Hash(String, Command).new
  @@all = Hash(String, Command).new
  @@link = String.new
  getter name, description

  enum Update
    Revoke
    Give
  end

  def initialize(
    @name : String,
    @description : String,
    species : String,
    &@proc : IRCMessage -> String
  )
    case species
    when "dynamic"
      @@dynamic[@name] = self
    when "static"
      @@static[@name] = self
    else
      raise "you wat. accepted speciess are dynamic and static. you gave us #{type}"
    end
  end

  def call(ircm : IRCMessage) : String
    @proc.call(ircm)
  end

  def self.parse_ircm(ircm : IRCMessage) : Tuple(Model::Ducky?, Array(String))
    ducky = Model::Ducky.find_by(username: ircm.username)
    args = ircm.words
    return ducky, args[1..]
  end

  def self.link
    @@link
  end

  def self.link=(nl)
    @@link = nl
  end

  def self.all : Hash(String, Command)
    @@all
  end

  def self.all=(new_all) : Hash(String, Command)
    @@all = new_all
  end

  def self.dynamic : Hash(String, Command)
    @@dynamic
  end

  def self.static : Array(String)
    @@static
  end

  def self.static=(new_static : Array(String))
    @@static = new_static
  end

  def self.link : String
    @@link
  end

  def self.link=(new_link)
    @@link = new_link
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
