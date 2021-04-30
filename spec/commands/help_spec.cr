require "../spec_helper"
require "../../src/chatty/commands/help"

describe "!help" do
  it "should display help for command" do
    Command.new(name: "!shiny", description: "makes your code super shiny!") do
      next "1.. 2.. 3.. SHINY!"
    end

    raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!help !shiny"
    ircm = IRCMessage.new(raw_irc)

    expected = "!shiny - makes your code super shiny!"
    actual = Command.all["!help"].call(ircm)

    actual.should eq expected

    # cleanup
    Command.all.delete("!shiny")
  end

  it "should display all commands if no args provided" do
    Command.new(name: "!shiny", description: "makes your code super shiny!") do
      next "1.. 2.. 3.. SHINY!"
    end

    raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!help"
    ircm = IRCMessage.new(raw_irc)

    expected = "commands: " + Command.all.keys.join(" | ")
    actual = Command.all["!help"].call(ircm)

    actual.should eq expected

    # cleanup
    Command.all.delete("!shiny")
  end

  it "should return error message if help is requested for unknown command" do
    raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!help !unknown"
    ircm = IRCMessage.new(raw_irc)

    expected = "whats !unknown? never seen 'em 'round here"
    actual = Command.all["!help"].call(ircm)

    actual.should eq expected
  end
end