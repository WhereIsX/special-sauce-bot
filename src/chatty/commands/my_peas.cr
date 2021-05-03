require "./command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!my_peas",
  description: "shows how many peas you have"
) do |ircm|
  ducky = Model::Ducky.find_by(username: ircm.username) # Model::Ducky | Nil
  if ducky
    next "you have #{ducky.points} peas!"
  else
    next "we couldn't find you; have you already !start_record ? "
  end
end
