require "./command.cr"

Command.new(
  name: "!echo",
  description: "im a parrot. :>  !echo <words> to make me say words" # HALP
) do |ircm|
  _, args = Command.parse_ircm(ircm)
  if args.empty?
    return "actually, it's !echo <words>"
  elsif duckie_args[0] == '/' || duckie_args[0] == '.' # super secure
    return "nice try. 👅"
  else
    return duckie_args
  end
end
