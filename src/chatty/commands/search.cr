require "./command.cr"
require "levenshtein"

Command.new(
  name: "!search",
  description: "search through all available commands; !search <command name>"
) do |ircm|
  _, args = Command.parse_ircm(ircm)

  if args.empty?
    next "o: give me a term to search by"
  end

  search_term = args.first.downcase

  possible_commands = Command
    .all
    .keys
    .map { |command_name|
      distance = Levenshtein.distance(command_name, search_term)
      {distance, command_name}
    }
    .select { |(distance, command_name)| distance <= 3 }
    .sort_by { |(distance, _)| distance }
    .map { |(_, command_name)| command_name }

  next possible_commands.to_s
end
