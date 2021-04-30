require "../spec_helper"
require "../../src/chatty/commands/echo"

describe "!echo" do
  it "should return string based on args provided" do
    raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!echo Hello world!"
    ircm = IRCMessage.new(raw_irc)

    expected = "Hello world!"
    actual = Command.all["!echo"].call(ircm)

    actual.should eq expected
  end

  it "should return error message if no args provided" do
    raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!echo"
    ircm = IRCMessage.new(raw_irc)

    expected = "actually, it's !echo <words>"
    actual = Command.all["!echo"].call(ircm)

    actual.should eq expected
  end

  it "should return error message if first char is ." do
    raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!echo ./sneaky"
    ircm = IRCMessage.new(raw_irc)

    expected = "nice try. 👅"
    actual = Command.all["!echo"].call(ircm)

    actual.should eq expected
  end

  it "should return error message if first char is /" do
    raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckies :!echo /sneaky"
    ircm = IRCMessage.new(raw_irc)

    expected = "nice try. 👅"
    actual = Command.all["!echo"].call(ircm)

    actual.should eq expected
  end
end