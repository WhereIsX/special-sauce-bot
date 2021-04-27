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
    @@all[@name] << self
  end

  def call(ircm) : String
    @proc.call(ircm)
  end

  def self.parse_ircm(ircm) : Tuple(Ducky?, Array(String))
    ducky = Ducky.find_by(ircm.username)
    args = ircm.message.split(" ", remove_empty: true)
    return ducky, args
  end

  def self.all
    @@all
  end
end
