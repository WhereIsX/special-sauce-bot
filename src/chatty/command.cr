require "http/client"
# sorted alphabetically by value (proc name) and then by key (command string)

DYNAMIC_COMMANDS = {
  "!help"     => ->Commands.cmd_help(String, String),
  "!commands" => ->Commands.cmd_help(String, String),
  "!damn"     => ->Commands.cmd_damn(String, String),
  "!echo"     => ->Commands.cmd_echo(String, String),
  "!feed"     => ->Commands.cmd_feed(String, String),
  "!leaked"   => ->Commands.cmd_leaked(String, String),
  "!my_peas"  => ->Commands.cmd_peas(String, String),
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
  "!todayishaved" => ->Commands.cmd_yak_topics(String, String),
}

SUPER_COWS = Set{
  "where_is_x", "anthonywritescode", "muumijumala", "somethingaboutus", "zklown", "zockle", "steve7411", "tanerax", "aigle_pt",
}

module Commands
  def self.cmd_help(caller_name : String, duckie_args : String)
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
  def self.cmd_consent(caller_name : String, duckie_args : String) : String
    update = Update.parse?(duckie_args)
    ducky = Ducky.find_by(username: caller_name)

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

  def self.cmd_create_duckie(caller_name : String, duckie_args : String)
    d = Ducky.create(username: caller_name)
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
      leak = Leak.new(created_at: Time.utc)
      if leak.save
        return "you get a new key! you get a new key! EVERYBODY GETS A NEW KEY!!"
      else
        return "create_new_leak is busted :( "
      end
    else
      return "not authorized to record a new !leaked keys time"
    end
  end

  def self.cmd_delete_duckie(caller_name : String, duckie_args : String)
    # !burn_record <caller_name>
    if caller_name != duckie_args.downcase
      return "who're you trying to delete? try !burn_record #{caller_name}"
    end
    # below this line, keep in mind that caller_name == duckie_args
    if ducky = Ducky.find_by(username: caller_name)
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

  def self.cmd_echo(caller_name : String, duckie_args : String)
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

    parsed_args = args.split(' ', remove_empty: true)
    if parsed_args.size != 2
      return "you wat. we expected 2 args."
    end
    prePoints, ducky_name = parsed_args
    points = prePoints.to_i { 0 } # try* to parse to int, if not default to 0
    ducky = Ducky.find_by(username: ducky_name.downcase)

    if ducky.nil?
      # maybe we should make them a record, WITHOUT their consent??
      return "oye! #{caller_name} we don't have a #{ducky_name} in our records. if they would like to receive the feed, they should !start_record ?"
    elsif points.zero?
      return "thats either an invalid number, or something something"
    elsif points.abs > 1000
      return "too much feed"
    else
      ducky.points += points
      if ducky.save
        return "#{ducky_name} now has #{ducky.points} peas"
      else
        return "wat"
      end
    end
  end

  def self.cmd_leaked(caller_name : String, duckie_args : String) : String
    leak_record = Leak.order(created_at: :desc).limit(1).select.first

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

  def self.cmd_peas(caller_name : String, duckie_args : String) : String
    ducky = Ducky.find_by(username: caller_name) # Ducky | Nil
    if ducky
      return "you have #{ducky.points} peas!"
    else
      return "we couldn't find you; have you already !start_record ? "
    end
  end

  def self.cmd_ping(caller_name : String, duckie_args : String)
    return PONG_FACTS.sample
  end

  def self.cmd_quote(caller_name : String, duckie_args : String)
    return QUOTES.sample
  end

  def self.cmd_shoutout(caller_name : String, duckie_args : String)
    return "nice try, 👅" if !valid_username?(duckie_args)
    # search_result = `twitch api get search/channels?query=#{duckie_args}`
    # data = JSON.parse(search_result).dig("data") # => JSON::Any
    # user = data.as_a.find { |user| user["display_name"].to_s.downcase == duckie_args.downcase }
    user = channel_lookup(duckie_args)
    if user
      return "go check out twitch.tv/#{user["display_name"]}, they were last working on '#{user["title"]}'"
    else
      return "you can't spell mat"
    end
  end

  def self.channel_lookup(channel_name : String)
    # this assumes that the channel_name doesnt try anything scary
    headers = HTTP::Headers{
      "Client-ID"     => ENV["TWITCH_APP_ID"],
      "Authorization" => "Bearer #{ENV["TWITCH_APP_ACCESS_TOKEN"]}",
    }
    result = HTTP::Client.get(
      url: "https://api.twitch.tv/helix/search/channels?query=#{channel_name}",
      headers: headers,
    )

    if !result.success?
      p! result
      raise "channel request failed with: #{result.status_code} "
    end
    data = JSON.parse(result.body).dig("data") # => JSON::Any
    user = data.as_a.find { |user| user["display_name"].to_s.downcase == channel_name.downcase }
    return user
  end

  def self.cmd_water(caller_name : String, args : String)
    # TBD: randomly picks a duck and tags them, asking them to drink
    duckie = Ducky.find_by(username: args.downcase)
    if duckie.nil?
      return "no such duckie, have they `!start_record` yet?"
    elsif duckie.at_me_consent
      return "HYDRATE #{args}! go get your feathers wet :>"
    else
      return "they didn't give us consent to water them :<"
    end
  end

  def self.cmd_yak_inc(caller_name : String, duckie_args : String)
    yak = Yak.new(created_at: Time.utc)
    if duckie_args
      yak.topic = duckie_args
    else
      yak.topic = ""
    end
    if yak.save
      yaks_shaved = self.cmd_yak_count("", "")
      # passing in two empty strings because proc expects exact # of args,
      # but isnt using them >_>;;
      return "that's #{yaks_shaved} now! " + YAK_INC_RESP.sample
    else
      return "couldn't shave. Waaat"
    end
  end

  def self.cmd_yak_count(caller_name : String, duckie_args : String)
    yaks = Yak.where(:created_at, :gt, 12.hours.ago).select.size

    if yaks.zero?
      return "the yaks are woolly; here're some Shears have a nice day!"
    else
      return yaks.to_s
    end
  end

  def self.cmd_yak_topics(caller_name : String, duckie_args : String)
    yaks = Yak.where(:created_at, :gt, 12.hours.ago)
      .where(:topic, :neq, "")
      .select

    topics = yaks.map { |yak| yak.topic }.join(", ")
    return "today we shaved: #{topics}"
  end

  # does caller_name try to escape and call more duckie_args in our terminal?!
  def self.valid_username?(username : String)
    /^[A-Za-z0-9_]{4,25}$/.matches?(username)
  end
end
