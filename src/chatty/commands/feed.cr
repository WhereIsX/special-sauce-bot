require "./command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!feed",
  description: "!feed <username> <integer = 10> give food to specific duck"
) do |ircm|
  # find caller record
  caller, args = Command.parse_ircm(ircm)

  # no caller record
  if caller.nil? || !caller.super_cow_power
    next "youre not a supercow.. are you sure you have SUDO cow powers?"
  end

  arg_size = args.size.to_u

  case arg_size
  when 1
    # give ducky the default amount of points
    points = 10
  when 2
    # try* to parse to int, if not default to 0
    points = args.last.to_i { 0 }
  else
    # wrong number of arguments
    next "wat.  try #{Command.all["!feed"].description}"
  end

  ducky = Ducky.find_by(username: args.first.downcase)
  # cant find ducky to feed
  if ducky.nil?
    next "hmm.. #{args.first} should !start_record to recieve feed"
  end

  if points.zero?
    next "#{caller} thats either an invalid number, or you're trying to trick our poor duckies into eating nothingness"
  elsif points.abs > 1000
    next "too much feed"
  end

  ducky.points += points

  if ducky.save
    next "after feeding #{points}, #{ducky.username} now has #{ducky.points} peas!"
  else
    next "we have the ducky and the peas. but couldn't save?"
  end
end
