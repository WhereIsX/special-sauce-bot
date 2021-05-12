require "./command.cr"

Command.new(
  name: "!help",
  description: "show help on specified command, or list commands if none specified; !help <command>",
  species: "dynamic"
) do |ircm|
  _, args = Command.parse_ircm(ircm)

  if args.empty?
    next "commands: " + Command.all.keys.join(" | ") # Hash(String, Command)
  end

  command = args.first
  if !Command.all.has_key?(command)
    next "whats #{command}? never seen 'em 'round here"
  end

  next command + " - " + Command.all[command].description
end
