require "./command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!my_pea_purse",
  description: "link to where you store your code; !my_pea_purse <link>"
) do |ircm|
  ducky, args = Command.parse_ircm(ircm)

  if ducky.nil?
    next "you wat.  you need a record with us first: !start_record"
  end

  if args.empty?
    next "you wat. it's !my_pea_purse <link>"
  end

  ducky.purse = args.first

  if ducky.save
    next "gotcha :>"
  else
    next "AMG. CALL THAT WAT DEV. we couldn't save??"
  end
end
