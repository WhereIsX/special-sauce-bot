require "./command.cr"

Command.new(
  name: "!feed",
  description: "!feed <username> <integer = 10> give food to specific duck"
) do |ircm|
  # find caller record
  caller, args = Command.parse_ircm(ircm)

  # no caller record
  if caller.nil? || !caller.super_cow_power
    return "youre not a supercow.. are you sure you have SUDO cow powers?"
  end
  # wrong number of arguments
  if args.size == 0 || args.size > 2
    return "wat.  try #{Command.all["!feed"].descrption}"
  end

  ducky = Ducky.find_by(username: args.first.downcase)
  # cant find ducky to feed
  if ducky.nil?
    return "hmm.. #{args.first} should !start_record to recieve feed"
  end

  case args.size
  when 1
    points = 10
    # give ducky the default amount of points
  when 2
    points = args.last.to_i { 0 }
    # try* to parse to int, if not default to 0
  end

  if points.zero?
    return "#{caller} thats either an invalid number, or you're trying to trick our poor duckies into eating nothingness"
  elsif points.abs > 1000
    return "too much feed"
  end

  ducky.points += points

  if ducky.save
    return "after feeding #{points}, #{ducky.name} now has #{ducky.points} peas!"
  else
    return "we have the ducky and the peas. but couldn't save?"
  end
end
