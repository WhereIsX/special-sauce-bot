require "./command.cr"

Command.new(
  name: "!link",
  description: "!link <optional: address>" # species: "dynamic"

) do |ircm|
  ducky, args = Command.parse_ircm(ircm)
  if Command.naughty?(args)
    if ducky.nil?
      next "/timeout #{ircm.username} 300"
    else
      next "ya wat. don't do that again #{ircm.username}"
      # maybe ill keep naughty list in the db
    end
  end
  case args.size
  when 0
    next Command.link
  when 1
    Command.link = ircm.words[1]
    next "got ya baws :>"
  else
    next "ya wat. it's !link <optional: address>"
  end
end
