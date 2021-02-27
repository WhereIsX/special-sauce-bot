require "json"

COMMAND_VOCABULARY = {
  "!help"     => ->cmd_help(String),
  "!commands" => ->cmd_help(String),
  "!damn"     => ->cmd_damn(String),
  "!echo"     => ->cmd_echo(String),
  "!emojis"   => ->cmd_emojis(String),
  "!leaked"   => ->cmd_leaked(String),
  "!ping"     => ->cmd_ping(String),
  "!sauce"    => ->cmd_sauce(String), # !recipe
  "!so"       => ->cmd_shoutout(String),
}

SUPER_COWS = Set{
  "where_is_x", "muumijumala", "somethingaboutus",
}

def cmd_help(stuff : String)
  intro_bit = "the commands are: "
  keys_bit = COMMAND_VOCABULARY.keys.sort.join(" | ")
  return intro_bit + keys_bit
end

def cmd_damn(stuff : String)
  return "eh?"
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

def cmd_feed(stuff : String)
  return ":>"
end

def cmd_leaked(stuff : String)
  return "eh?"
end

def cmd_ping(stuff : String)
  return PONG_FACTS.sample
end

def cmd_sauce(stuff : String)
  return "https://github.com/WhereIsX/special-sauce-bot"
end

# does username try to escape and call more stuff in our terminal?!
def valid_username?(username : String)
  /^[A-Za-z0-9_]{4,25}$/.matches?(username)
end

def cmd_shoutout(username : String)
  return "nice try, 👅" if !valid_username?(username)
  search_result = `twitch api get search/channels?query=#{username}`
  data = JSON.parse(search_result).dig("data") # => JSON::Any
  user = data.as_a.find { |user| user["display_name"].to_s.downcase == username.downcase }
  if user
    return "go check out twitch.tv/#{user["display_name"]}, they were last working on '#{user["title"]}'"
  else
    return "you can't spell mate"
  end
end
