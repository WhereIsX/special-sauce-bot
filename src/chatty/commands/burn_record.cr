require "./command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!burn_record",
  description: "quack along the dotted line to delete your record \
  from our database; !burn_record <self_username>",

  species: "dynamic"
) do |ircm|
  if ircm.username != ircm.words[1].downcase
    next "who're you trying to delete? try !burn_record #{ircm.username}"
  end
  # below this line, keep in mind that ircm.username == duckie_args
  if ducky = Model::Ducky.find_by(username: ircm.username)
    ducky.destroy
    if ducky.destroyed?
      next "burnt to a crisp!"
    else
      next "we found your record but couldn't destroy it..?"
    end
  else
    next "wat. you don't have a record"
  end
end
