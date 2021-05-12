require "./command.cr"

Command.new(
  name: "!link",
  description: "!link <optional: address>" # species: "dynamic"

) do |ircm|
  case ircm.words.size
  when 1
    next Command.link
  when 2
    Command.link = ircm.words[1]
    next "got ya baws :>"
  else
    next "ya wat. it's !link <optional: address>"
  end
end
