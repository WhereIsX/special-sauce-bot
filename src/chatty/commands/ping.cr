require "./command.cr"
require "../../data/constants_collection.cr"

Command.new(
  name: "!ping",
  description: "tells a pong fact :>"
) do |ircm|
  PONG_FACTS.sample
end
