COMMAND_VOCABULARY = {
  "!help"     => ->cmd_help(String),
  "!commands" => ->cmd_help(String),
  "!echo"     => ->cmd_echo(String),
  "!emojis"   => ->cmd_emojis(String),
  "!ping"     => ->cmd_ping(String),
}

PONG_FACTS = [
  ":ping_pong: is a nice game",
  ":ping_pong: yourself",
  ":ping_pong: https://en.wikipedia.org/wiki/Pong",
  ":ping_pong: gers",
  "29 November 1972 is when :ping_pong: was released",
  ":ping_pong: was the first game developed by atari",
  ":ping_pong: https://en.wikipedia.org/wiki/Pong#/media/File:Signed_Pong_Cabinet.jpg",
]

def cmd_help(stuff : String)
  intro_bit = "the commands are: "
  keys_bit = COMMAND_VOCABULARY.keys.sort.join(" | ")
  return intro_bit + keys_bit
end

def cmd_echo(stuff : String)
  if stuff.empty?
    return "actually, it's !echo <stuff you want me to say>"
  elsif stuff[0] == '/' || stuff[0] == '.' # super secure
    return "nice try. 👅"
  else
    return stuff
  end
end

def cmd_emojis(stuff : String)
  return "Waaat Shears Woool QuackTogether"
end

def cmd_ping(stuff : String)
  return PONG_FACTS.sample
end

TWITCH_MOD_COMMANDS = [
  "/ban",
  "/clear",
  "/disconnect",
  "/emoteonly",
  "/emoteonlyoff",
  "/followers",
  "/followersoff",
  "/host",
  "/marker",
  "/me",
  "/mod",
  "/mods",
  "/raid",
  "/slow",
  "/slowoff",
  "/subscribers",
  "/subscribersoff",
  "/timeout",
  "/unban",
  "/unblock",
  "/unhost",
  "/uniquechat",
  "/uniquechatoff",
  "/unmod",
  "/unraid",
  "/unvip",
  "/user",
  "/vip",
  "/vips",
  "/w",
]
