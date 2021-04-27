require "./command.cr"

Command.new(
  name: "!help",
  description: "show help on specified command, or list commands if none specified; !help <command>"
) do |ircm|
  _, args = Command.parse_ircm(ircm)

  if args.empty?
    return "commands: " + Command.all.keys.join(" | ") # Hash(String, Command)
  end

  command = arg.first
  if !Command.all.has_key?(command)
    return "whats #{command}? never seen 'em 'round here"
  end

  return command + " - " + Command.all[command].description
end
