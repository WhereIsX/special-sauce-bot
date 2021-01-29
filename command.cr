# key has to fit exactly
#   !uptime, !lurk
COMMAND_VOCABULARY = {
  "!echo"   => ->(stuff : String) { stuff },
  "!emojis" => ->{ "Waaat Shears Woool QuackTogether" },
  "!ping"   => ->{ PONG_FACTS.sample },
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
