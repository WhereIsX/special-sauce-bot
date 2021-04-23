# GOAL:
# make it so that we can add new commands under their own file
# aka dont want to shove all commands in 1 file

# AND combine static && dynamic commands under this module

# remove from Chatty:
# @@static_commands
# reload_static_commands



# ----- THOUGHTS ------ 

# MUUMI VERSION

each (bot.on("!command_name_here") do &block)
in its own file, in a directory called commands? 
bot.on("!help") 


# INHERITANCE VERSION 
# abstract Class Commands, new commands == class inherit from Commands
# pros: all commands get to be in their own file 
# cons: so many small classes 


# CLASS VERSION
# commands are instances of Class Command
# pros: easy to make help, 
  # easy to make new commands w everthing pertaining to it in the same file 

# commands/command.cr
class Command 
  @@all = Hash(String, Command)

  def initialize(@name, @description, &@block : IRCMessage -> String)
    @@all[@name] << self
  end 

  def call(ircm)
   @exec.call(ircm)
  end 

  def self.all 
    @@all 
  end 
end

# commands/feed.cr
Command.new("feed", "give food to specific duck") do |ircm|
  ducky = Ducky.find(@caller_name)
  # more logic 
end 

"!help !feed"
# commands/help.cr
Command.new("help", "") do |ircm|
  Command.all 
end

# chatty.cr
if command = ircm.command?
  command.call(ircm)






# module Commands w individual modules inside
# pros: commands in separate files, can take 0+ arguments 
# cons: when adding new commands, we would haev to add it in 2+ places
  # 1. the router `self.run`
  # 2. the help function 
  # 3. the module it lives inside 

module Commands
  module Test
  end

  module Help
    def self.help(cmd)
      case cmd 

      when "!test_cmd"
        return "test descritpion of how to use test "
      end
  end 
  end 

  module Router 
  
  
    def self.run(cmd : String, caller_name : String = "", args : String = "")
      case cmd
      when "!test_command"
        Test.exec()
      when "!burn_record"
        DuckCmd.delete()
      when "!commands"
        Help.help()
      when "!consent"
        DuckCmd.update_consent()
      when "!damn"
        LeakCmd.create()
      when "!echo"
        BotFun.echo()
      when "!feed"
        DuckCmd.update_points()
      when "!help"
        Help.help()
      # when "!joke"
      #   BotFun.joke()
      when "!leaked"
        LeakCmd.get_since_last()
      when "!my_peas"
        DuckCmd.get_peas_count()
      when "!ping"
        BotFun.pong()
      when "!quote"
        BotFun.quote()
      when "!reload"
        Settings.reload()
      when "!so"
        BotFun.shoutout()
      when "!start_record"
        DuckCmd.create()
      when "!todayishaved"
        YakCmd.get_with_details()
      when "!wat"
        Static.exec(cmd)
      when "!water"
        # !water without args should pick a rando online
          # keep a list of people who have spoken in chat so far today 
          # @ them to hydrate  
        BotFun.water()
      when "!whoami"
        DuckCmd.get()
      when "!yak++"
        YakCmd.inc()
      when "!yak_count"
        YakCmd.get_count()
      end
      
      
    end 
  end 