# sorted alphabetically by value (proc name) and then by key (command string)

DYNAMIC_COMMANDS = {
  "!help"     => ->Commands.cmd_help(String, String),
  "!commands" => ->Commands.cmd_help(String, String),
  "!damn"     => ->Commands.cmd_damn(String, String),
  "!echo"     => ->Commands.cmd_echo(String, String),
  "!feed"     => ->Commands.cmd_feed(String, String),
  "!leaked"   => ->Commands.cmd_leaked(String, String),
  "!ping"     => ->Commands.cmd_ping(String, String),
  "!quote"    => ->Commands.cmd_quote(String, String),
  "!so"       => ->Commands.cmd_shoutout(String, String),
  "!water"    => ->Commands.cmd_water(String, String),
  # "!uptime" => ->Commands.cmd_uptime(String, String),
  # "!whoami" => ->Commands.cmd_whoami(String, String),

  "!start_record" => ->Commands.cmd_create_duckie(String, String),
  "!burn_record"  => ->Commands.cmd_delete_duckie(String, String),
  "!consent"      => ->Commands.cmd_consent(String, String),
  "!yak_count"    => ->Commands.cmd_yak_count(String, String),
  "!yak++"        => ->Commands.cmd_yak_inc(String, String),
}

SUPER_COWS = Set{
  "where_is_x", "anthonywritescode", "muumijumala", "somethingaboutus", "zklown", "zockle", "steve7411", "tanerax", "aigle_pt",
}

module Commands
  def self.cmd_help(username : String, duckie_args : String)
    intro_bit = "the commands are: "
    keys_bit = DYNAMIC_COMMANDS.keys.sort.join(" | ")
    return intro_bit + keys_bit
  end

  enum Update
    Revoke
    Give
  end

  # usename: !consent <give/revoke>
  #                   ^duckie_args^
  def self.cmd_consent(username : String, duckie_args : String) : String
    update = Update.parse?(duckie_args)
    ducky = Ducky.find_by(username: username)

    if ducky.nil?
      return "sorry, we couldn't find you. have you already `!start_record` ?"
    end

    case update
    in Nil
      return "try !consent <give/revoke>"
    in Update::Revoke
      ducky.at_me_consent = false
    in Update::Give
      ducky.at_me_consent = true
    end
    if ducky.save
      return "aye aye!"
    else
      return "that failed :( time to git blame/annotate where_is_x"
    end
  end

  def self.cmd_create_duckie(username : String, duckie_args : String)
    d = Ducky.create(username: username)
    if d.errors.empty?
      return "welcome to the flock!"
    else # we hit some kinda error... :/
      return "we couldn't start a record for you. you might already have one Waaat"
    end
  end

  # 4'5 duck
  def self.cmd_damn(caller_name : String, args : String)
    # we dont want just any regular user calling this method (prevent abuse!)
    d = Ducky.find_by(username: caller_name) # Ducky | Nil
    if d && d.super_cow_power                # is the caller a super_cow?
      leak = Leak.new
      if leak.save
        return "you get a new key! you get a new key! EVERYBODY GETS A NEW KEY!!"
      else
        return "create_new_leak is busted :( "
      end
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
    if ducky = Ducky.find_by(username: username)
      ducky.destroy
      if ducky.destroyed?
        return "burnt to a crisp!"
      else
        return "we found your record but couldn't destroy it..?"
      end
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

  def self.cmd_feed(caller_name : String, args : String)
    if !SUPER_COWS.includes?(caller_name)
      return "*squint* you dont look like a super cow.. are you sure you have SUDO cow powers?"
    end

    prePoints, ducky_name = args.split(' ', remove_empty: true)
    points = prePoints.to_i { 0 } # try* to parse to int, if not default to 0
    ducky = Ducky.find_by(username: ducky_name)

    if ducky.nil?
      return "oye! #{caller_name} we don't have a #{ducky_name} in our records. have they !start_record ?"
    elsif points.zero?
      return "thats either an invalid number, or something something"
    elsif points.abs > 1000
      return "too much feed"
    else
      ducky.points += points
      if ducky.save
        return "#{ducky_name} now has #{ducky.points}"
      else
        return "wat"
      end
    end
  end

  def self.cmd_leaked(username : String, duckie_args : String) : String
    leak_record = Leak.all.last

    return "there were no leaks 🙃" if leak_record.nil?
    span = Time.utc - leak_record.created_at
    if span > 1.days
      return "#{span.days} days since we last ducked up"
    elsif span > 1.hours
      return "#{span.hours} hours since we last ducked up"
    else
      return "#{span.minutes} minutes since we last ducked up"
    end
    return "heyyo"
  end

  def self.cmd_ping(username : String, duckie_args : String)
    return PONG_FACTS.sample
  end

  def self.cmd_quote(username : String, duckie_args : String)
    return QUOTES.sample
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

  def self.cmd_water(caller_name : String, args : String)
    # TBD: randomly picks a duck and tags them, asking them to drink
    duckie = Ducky.find_by(username: args)
    if duckie.nil?
      return "no such duckie, have they `!start_record` yet?"
    elsif duckie.at_me_consent
      return "HYDRATE #{args}! go get your feathers wet :>"
    else
      return "they didn't give us consent to water them :<"
    end
  end

  def self.cmd_yak_inc(username : String, duckie_args : String)
    File.open("yak_counter", "a") do |f|
      f.puts Time.utc.to_rfc2822 + "<#{username}>"
    end
    yaks_shaved = self.cmd_yak_count("", "")

    return "that's #{yaks_shaved} now! " + YAK_INC_RESP.sample
  end

  def self.cmd_yak_count(username : String, duckie_args : String)
    yaks = File.read("yak_counter")
    time_collection = yaks.split("\n", remove_empty: true).map do |line|
      # p! line.split('<').first
      Time.parse_rfc2822(line.split('<').first)
    end
    oldest_yak = time_collection.bsearch_index do |yak_time|
      12.hours.ago < yak_time
    end
    if oldest_yak
      return (time_collection.size - oldest_yak).to_s
    else
      return "all the yaks are fully woolly; here're some Shears have a nice day!"
    end
  end

  # does username try to escape and call more duckie_args in our terminal?!
  def self.valid_username?(username : String)
    /^[A-Za-z0-9_]{4,25}$/.matches?(username)
  end
end
