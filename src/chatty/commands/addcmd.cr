require "./command.cr"
require "../../models/command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!addcmd",
  description: "adds a command to the database (costs 50 peas); !addcmd <command_name> <response>"
) do |ircm|
  ducky, arg = Command.parse_ircm(ircm)

  if ducky.nil?
    next "you must have a record with us to make a new command"
  end

  if ducky.created_at > 1.week.ago
    next "your record must be at least 1 week old to make a new command"
  end

  if ducky.points < 50
    # next "you're broke fam. try earning more peas by watering your fellow duckies (!water).  psst-- x_is_here also takes bribes :>"
    next "you're broke fam.  try earning more peas"
  end

  new_cmd = Model::Command.create(name: arg.first, response: arg[1..].join(' '), created_at: Time.utc)

  if new_cmd.errors.any?
    puts new_cmd.errors
    e = new_cmd.errors.first
    next "OMG ITS ON FIRE! CALL TECH SUPOPRT RIGHT MEOW and tell them its about #{e.field}: #{e.message}"
  else
    ducky.points -= 50
    ducky.save
    next "you did it!  you made a command!  now `!reload` and try calling #{arg.first} to see it in action :>"
  end
end
