require "./command.cr"

Command.new(
  name: "!echo",
  description: "im a parrot. :>  !echo <words> to make me say words" # HALP
) do |ircm|
  _, args = Command.parse_ircm(ircm)
  if args.empty?
    next "actually, it's !echo <words>"
  elsif args[0] == '/' || args[0] == '.' # super secure
    next "nice try. 👅"
  else
    next args.join(' ')
  end
end
