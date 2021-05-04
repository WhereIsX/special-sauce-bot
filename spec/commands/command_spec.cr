require "db"
require "../spec_helper"

describe Command do
  describe "#initialize" do
    it "should raise an ArgumentError if name is undefined" do
      expect_raises(ArgumentError) do
        Command.new(name: "", description: "") do |ircm|
          next "should fail"
        end
      end
    end

    it "should append new command to @@all" do
      Command.new(name: "!test", description: "testing @all") do
        next "shiny test!"
      end

      Command.all["!test"].should_not be_nil

      # cleanup
      Command.all.delete("!test")
    end
  end

  describe ".all" do
    it "should return a hash containing all initialized commands" do
      Command.new(name: "!eat", description: "yum yum.. food!") do
        next "eating..."
      end

      Command.new(name: "!sleep", description: "Yana will go sleep for 30 minutes") do
        next "Zzzz Zzzz"
      end

      Command.all["!eat"].should_not be_nil
      Command.all["!sleep"].should_not be_nil

      # cleanup
      Command.all.delete("!eat")
      Command.all.delete("!sleep")
    end
  end

  describe "#call" do
    it "should ..." do
      Command.new(name: "!shiny", description: "makes your code super shiny!") do
        next "1.. 2.. 3.. SHINY!"
      end
      raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!shiny"
      ircm = IRCMessage.new(raw_irc)

      expected = "1.. 2.. 3.. SHINY!"
      actual = Command.all["!shiny"].call(ircm)

      actual.should eq expected

      # cleanup
      Command.all.delete("!shiny")
    end
  end

  describe ".is_command?" do
    it "should return true if command" do
      Command.new(name: "!shiny", description: "makes your code super shiny!") do
        next "1.. 2.. 3.. SHINY!"
      end
      raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!shiny"
      ircm = IRCMessage.new(raw_irc)

      Command.is_command?(ircm).should be_true

      # cleanup
      Command.all.delete("!shiny")
    end

    it "should return false if not command" do
      raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!unknown-command"
      ircm = IRCMessage.new(raw_irc)

      Command.is_command?(ircm).should be_false
    end
  end

  describe ".get_command" do
    it "should return requested command" do
      Command.new(name: "!shiny", description: "makes your code super shiny!") do
        next "1.. 2.. 3.. SHINY!"
      end
      raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!shiny"
      ircm = IRCMessage.new(raw_irc)

      command = Command.get_command(ircm)

      command.should_not be_nil
      command.name.should eq "!shiny"
      command.description.should eq "makes your code super shiny!"

      # cleanup
      Command.all.delete("!shiny")
    end

    it "should raise an ArgumentError if unknown command" do
      expect_raises(ArgumentError) do
        raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!unknown"
        ircm = IRCMessage.new(raw_irc)

        Command.get_command(ircm)
      end
    end
  end
end