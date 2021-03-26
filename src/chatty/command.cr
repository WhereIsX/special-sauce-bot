require "./dblibrarian.cr"

# sorted alphabetically by value (proc name) and then by key (command string)

DYNAMIC_COMMANDS = {
  "!help"     => ->Commands.cmd_help(String, String),
  "!commands" => ->Commands.cmd_help(String, String),
  "!damn"     => ->Commands.cmd_damn(String, String),
  "!echo"     => ->Commands.cmd_echo(String, String),
  "!leaked"   => ->Commands.cmd_leaked(String, String),
  "!ping"     => ->Commands.cmd_ping(String, String),
  "!so"       => ->Commands.cmd_shoutout(String, String),
  "!water"    => ->Commands.cmd_water(String, String),
  # "!uptime" => ->Commands.cmd_uptime(String, String),
  # "!whoami" => ->Commands.cmd_whoami(String, String),

  "!start_record" => ->Commands.cmd_create_duckie(String, String),
  "!burn_record"  => ->Commands.cmd_delete_duckie(String, String),
  "!consent"      => ->Commands.cmd_consent(String, String),
}

SUPER_COWS = Set{
  "where_is_x", "muumijumala", "somethingaboutus", "zockle", "steve7411", "tanerax", "aigle_pt",
}

module Commands
  # datamaster
  LIBRARIAN = DBLibrarian.new

  def self.cmd_help(username : String, duckie_args : String)
    intro_bit = "the commands are: "
    keys_bit = DYNAMIC_COMMANDS.keys.sort.join(" | ")
    return intro_bit + keys_bit
  end

  enum Update
    Revoke
    Give
  end

  enum Consents
    Water
    AtMe # TB deprecated
  end

  def self.cmd_consent(username : String, duckie_args : String) : String
    parsed_args = duckie_args.split(" ", 2)
    update = Update.parse?(parsed_args.first)
    consent = Consents.parse?(parsed_args.last.delete(' '))
    return "try !consent <give/revoke> <at me/water>" if update.nil? || consent.nil?
    if LIBRARIAN.get_duckie(username).nil? # Duckie | Nil
      return "sorry, we couldn't find you. have you already `!start_record` ?"
    end
    case consent
    in Consents::Water
      LIBRARIAN.water_consent(username, update.value)
      return "okay"
    in Consents::AtMe
      LIBRARIAN.at_me_consent(username, update.value)
      return "okay"
    end
  end

  def self.cmd_create_duckie(username : String, duckie_args : String)
    if LIBRARIAN.create_duckie(username)
      return "welcome to the flock!"
    else
      return "we couldn't start a record for you. you might already have one Waaat"
    end
  end

  # 4'5 chad yana
  def self.cmd_damn(username : String, duckie_args : String)
    if SUPER_COWS.includes?(username)
      File.open("last_leaked", "a") do |f| # time.to_rfc2822(file_location)
        f.puts "#{Time.utc.to_rfc2822}"
      end
      return "you get a new key! you get a new key! EVERYBODY GETS A NEW KEY!!"
    else
      return "not authorized to record a new !leaked keys time"
    end
  end

  def self.cmd_delete_duckie(username : String, duckie_args : String)
    # !burn_record <username>
    if username != duckie_args.downcase
      return "who're you trying to delete? try !burn_record #{username}"
    end
    # below this line, keep in mind that username == duckie_args
    if LIBRARIAN.delete_duckie(username)
      return "burnt to a crisp!"
    else
      return "wat. you don't have a record"
    end
  end

  def self.cmd_echo(username : String, duckie_args : String)
    if duckie_args.empty?
      return "actually, it's !echo <duckie_args you want me to say>"
    elsif duckie_args[0] == '/' || duckie_args[0] == '.' # super secure
      return "nice try. 👅"
    else
      return duckie_args
    end
  end

  def self.cmd_feed(username : String, duckie_args : String)
    return ":>" # sqlite db
  end

  def self.cmd_leaked(username : String, duckie_args : String)
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

  def self.cmd_ping(username : String, duckie_args : String)
    return PONG_FACTS.sample
  end

  def self.cmd_shoutout(username : String, duckie_args : String)
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

  def self.cmd_water(username : String, duckie_args : String)
    # randomly picks a duck and tags them, asking them to drink
    # write to file for list of ducks for whom we have consent
    duckie = LIBRARIAN.get_duckie(duckie_args.downcase)
    if duckie.nil?
      return "no such duckie"
    elsif duckie[:water_consent]
      return "HYDRATE #{duckie_args}! go get your feathers wet :>"
    else
      return "they didn't give us consent to water them :<"
    end
  end

  # does username try to escape and call more duckie_args in our terminal?!
  def self.valid_username?(username : String)
    /^[A-Za-z0-9_]{4,25}$/.matches?(username)
  end
end
