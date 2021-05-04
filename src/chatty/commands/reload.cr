require "./command.cr"
require "../../models/command.cr"

Command.new(
  name: "!reload",
  description: "reload static commands from db"
) do |ircm|
  # @@static = ["!so", "!lurk"]
  # static commands in db changed => ["!so", "!welcome"]
  # @@static still contains !lurk
  # so if we reload without deleting first,
  # we would have commands "!so"(new), "!welcome', *AND* "!lurk"

  # delete the previously loaded commands
  # from collection of commands (@@all)
  Command.static.each do |cmd_name|
    Command.all.delete(cmd_name)
  end

  # take all the commands from DB
  # and make them into Commands to be used in chat
  db_cmds = Model::Command.all
  db_cmds.each do |cmd|
    next if Command.all.has_key?(cmd.name)
    Command.new(
      name: cmd.name,
      description: "static command-- simply type #{cmd.name}"
    ) { |_| cmd.response }
  end

  # set @@static to an [] of cmd.names
  Command.static = db_cmds.map { |c| c.name }

  next "i think i did it?"
end
