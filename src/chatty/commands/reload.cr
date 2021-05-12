require "./command.cr"
require "../../models/command.cr"

Command.new(
  name: "!reload",
  description: "reload static commands from db",
  species: "dynamic"
) do |_|
  Command.static = Hash(String, Command).new
  # for each command from the database,
  # make a static command
  Model::Command.all.each do |cmd|
    Command.new(
      name: cmd.name,
      description: "static command-- simply type #{cmd.name}",
      species: "static"
    ) { |_| cmd.response }
  end

  Command.all = Command.static.merge(Command.dynamic)

  next "i think i did it?"
end
