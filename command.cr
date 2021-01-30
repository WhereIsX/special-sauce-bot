COMMAND_VOCABULARY = {
  "!help"     => ->cmd_help(String),
  "!commands" => ->cmd_help(String),
  "!echo"     => ->cmd_echo(String),
  "!emojis"   => ->cmd_emojis(String),
  "!ping"     => ->cmd_ping(String),
}

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
