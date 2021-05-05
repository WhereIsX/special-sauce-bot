require "spec"
require "../src/chatty/irc_message"

describe IRCMessage do
  describe "#is_ping?" do
    it "should return true if @type is equal to IRCMessage::Ping" do
      raw_irc = "PING :tmi.twitch.tv"
      ircm = IRCMessage.new(raw_irc)

      ircm.is_ping?.should be_true
    end

    it "should return false if @type is not equal to IRCMessage::Ping" do
      raw_irc = ":tmi.twitch.tv CLEARCHAT #duckers :test-ducky"
      ircm = IRCMessage.new(raw_irc)

      ircm.is_ping?.should be_false
    end
  end

  describe "#is_user_msg?" do
    it "should return true if @type is equal to IRCMessage::UserMessage" do
      raw_irc = "<user>!<user>@<user>.tmi.twitch.tv PRIVMSG #duckers :hmmm..."
      ircm = IRCMessage.new(raw_irc)

      ircm.is_user_msg?.should be_true
    end

    it "should return false if @type is not equal to IRCMessage::UserMessage" do
      raw_irc = ":tmi.twitch.tv CLEARCHAT #duckers :test-ducky"
      ircm = IRCMessage.new(raw_irc)

      ircm.is_user_msg?.should be_false
    end
  end

  describe "#user_message?" do
    it "should return true if raw_irc contains the word PRIVMSG" do
      raw_irc = "<user>!<user>@<user>.tmi.twitch.tv PRIVMSG #duckers :hmmm..."
      ircm = IRCMessage.new(raw_irc)

      ircm.is_user_msg?.should be_true
    end

    it "should return false if raw_irc does not contains the word PRIVMSG" do
      raw_irc = ":tmi.twitch.tv CLEARCHAT #duckers :test-ducky"
      ircm = IRCMessage.new(raw_irc)

      ircm.is_user_msg?.should be_false
    end
  end

  # describe "#twitch_message?" do
  # it "should return true if raw_irc starts with :tmi.twitch.tv" do
  #   raw_irc = ":tmi.twitch.tv CLEARCHAT #duckers :test-ducky"
  #   ircm = IRCMessage.new(raw_irc)

  #   ircm.twitch_message?.should be_true
  # end

  #   it "should return false if raw_irc does not starts with :tmi.twitch.tv" do
  #     raw_irc = "<user>!<user>@<user>.tmi.twitch.tv PRIVMSG #duckers :hmmm..."
  #     ircm = IRCMessage.new(raw_irc)

  #     ircm.twitch_message?.should be_false
  #   end
  # end

  # describe "#parse_type" do
  #   it "should return MessageType::Ping if ping?" do
  #     raw_irc = "PING :tmi.twitch.tv"
  #     ircm = IRCMessage.new(raw_irc)

  #     ircm.parse_type.should eq IRCMessage::MessageType::Ping
  #   end

  #   it "should return MessageType::UserMessage if user_message?" do
  #     raw_irc = "<user>!<user>@<user>.tmi.twitch.tv PRIVMSG #duckers :hmmm..."
  #     ircm = IRCMessage.new(raw_irc)

  #     ircm.parse_type.should eq IRCMessage::MessageType::UserMessage
  #   end

  #   it "should return MessageType::TwitchMessage if twitch_message?" do
  #     raw_irc = ":tmi.twitch.tv CLEARCHAT #duckers :test-ducky"
  #     ircm = IRCMessage.new(raw_irc)

  #     ircm.parse_type.should eq IRCMessage::MessageType::TwitchMessage
  #   end
  # end

  # describe "#parse" do
  #   it "should tags, username and message" do
  #     raw_irc = "@login=<login>;target-msg-id=<target-msg-id> :yana!yana@yana.tmi.twitch.tv PRIVMSG #duckers :shiny!"
  #     ircm = IRCMessage.new(raw_irc)

  #     tags = {"@login" => "<login>", "target-msg-id" => "<target-msg-id>"}
  #     username = "yana"
  #     message = "shiny!"

  #     parsed_data = ircm.parse

  #     parsed_data[:tags].should eq tags
  #     parsed_data[:username].should eq username
  #     parsed_data[:message].should eq message
  #   end
  # end
end
