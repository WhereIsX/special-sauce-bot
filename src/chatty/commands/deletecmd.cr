require "./command.cr"
require "../../models/command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!deletecmd",
  description: "deletes a command to the database, you need to be a supercow to do this; !deletecmd <command_name>"
) do |ircm|
  ducky, arg = Command.parse_ircm(ircm)

  if ducky.nil?
    next "you must have a record with us to delete a new command"
  end

  if ducky.created_at > 1.week.ago
    next "your record must be at least 1 week old to delete a command"
  end

  if ducky.points < 50
    # next "you're broke fam. try earning more peas by watering your fellow duckies (!water).  psst-- x_is_here also takes bribes :>"
    next "you're broke fam.  try earning more peas"
  end

  if cmd = Model::Command.find_by(name: arg[0])
    cmd.destroy
    if cmd.destroyed?
      next "destroyed!"
    else
      next "that didn't work"
    end
  else
    next "I couldn't find #{arg[0]}"
  end
end
