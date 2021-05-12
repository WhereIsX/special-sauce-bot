require "./command.cr"
require "../../data/constants_collection.cr"

Command.new(
  name: "!quote",
  description: "gives you a quote YANA likes",
  species: "dynamic"
) do |ircm|
  QUOTES.sample
end
