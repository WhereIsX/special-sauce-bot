# key has to fit exactly
#   !uptime, !lurk

def cmd_echo(stuff : String)
  if stuff.empty?
    return "actually, it's !echo <stuff you want me to say>"
  elsif stuff[0] == '/' || stuff[0] == '.' # super secure
    return "nice try. 👅"
  else
    return stuff
  end
end

COMMAND_VOCABULARY = {
  # "!help" =>
  # "!commands" =>
  "!echo"   => ->cmd_echo(String),
  "!emojis" => ->(stuff : String) { return "Waaat Shears Woool QuackTogether" },
  "!ping"   => ->(stuff : String) { return PONG_FACTS.sample },
}

PONG_FACTS = [
  ":ping_pong: is a nice game",
  ":ping_pong: yourself",
  ":ping_pong:: https://en.wikipedia.org/wiki/Pong",
  ":ping_pong:gers",
  "29 November 1972 is when :ping_pong: was released",
  ":ping_pong: was the first game developed by atari",
  ":ping_pong: https://en.wikipedia.org/wiki/Pong#/media/File:Signed_Pong_Cabinet.jpg",
]

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
