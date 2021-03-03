require "json"

COMMAND_VOCABULARY = {
  "!help"     => ->cmd_help(String, String),
  "!commands" => ->cmd_help(String, String),
  "!damn"     => ->cmd_damn(String, String),
  "!echo"     => ->cmd_echo(String, String),
  "!emojis"   => ->cmd_emojis(String, String),
  "!leaked"   => ->cmd_leaked(String, String),
  "!ping"     => ->cmd_ping(String, String),
  "!sauce"    => ->cmd_sauce(String, String), # !recipe
  "!so"       => ->cmd_shoutout(String, String),
}

SUPER_COWS = Set{
  "where_is_x", "muumijumala", "somethingaboutus",
}

def cmd_help(username : String, duckie_args : String)
  intro_bit = "the commands are: "
  keys_bit = COMMAND_VOCABULARY.keys.sort.join(" | ")
  return intro_bit + keys_bit
end

# def cmd_naked_yaks

def cmd_damn(username : String, duckie_args : String)
  if SUPER_COWS.includes?(username)
    File.open("last_leaked", "a") do |f| # time.to_rfc2822(file_location)
      f.puts "#{Time.utc.to_rfc2822}"
    end
    return "success!"
  else
    return "no."
  end
end

def cmd_echo(username : String, duckie_args : String)
  if duckie_args.empty?
    return "actually, it's !echo <duckie_args you want me to say>"
  elsif duckie_args[0] == '/' || duckie_args[0] == '.' # super secure
    return "nice try. 👅"
  else
    return duckie_args
  end
end

def cmd_emojis(username : String, duckie_args : String)
  return "Waaat Shears Woool QuackTogether"
end

def cmd_feed(username : String, duckie_args : String)
  return ":>"
end

def cmd_leaked(username : String, duckie_args : String)
  last_leaked = Time.parse_rfc2822(File.read("last_leaked").split("\n")[-2])
  span = Time.utc - last_leaked

  if span > 1.days
    return "#{span.days} days since we last ducked up"
  elsif span > 1.hours
    return "#{span.hours} hours since we last ducked up"
  else
    return "#{span.minutes} minutes since we last ducked up"
  end
end

def cmd_ping(username : String, duckie_args : String)
  return PONG_FACTS.sample
end

def cmd_sauce(username : String, duckie_args : String)
  return "https://github.com/WhereIsX/special-sauce-bot"
end

def cmd_shoutout(username : String, duckie_args : String)
  return "nice try, 👅" if !valid_username?(duckie_args)
  search_result = `twitch api get search/channels?query=#{duckie_args}`
  data = JSON.parse(search_result).dig("data") # => JSON::Any
  user = data.as_a.find { |user| user["display_name"].to_s.downcase == duckie_args.downcase }
  if user
    return "go check out twitch.tv/#{user["display_name"]}, they were last working on '#{user["title"]}'"
  else
    return "you can't spell mate"
  end
end

# does username try to escape and call more duckie_args in our terminal?!
def valid_username?(username : String)
  /^[A-Za-z0-9_]{4,25}$/.matches?(username)
end
