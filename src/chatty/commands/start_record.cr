require "./command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!start_record",
  description: "starts a record to keep track of points and allows the bot to @ducky for water",
  species: "dynamic"
) do |ircm|
  d = Model::Ducky.create(username: ircm.username)
  if d.errors.empty?
    next "welcome to the flock!"
  else # we hit some kinda error... :/
    next "we couldn't start a record for you. you might already have one Waaat"
  end
end
