require "./command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!whoami",
  description: "in case you forgot, we can recite your info from our records (db) :>"
) do |ircm|
  d = Model::Ducky.find_by(username: ircm.username) # Model::Ducky | Nil
  if d
    next "you are #{d.username} Waaat \
    joined: #{d.created_at.to_s("%F")} Waaat \
    pea purse: #{d.purse.empty? ? "unknown" : d.purse} Waaat \
    sudo cow power: #{d.super_cow_power ? "Yay" : "Nay"} Waaat \
    consent (to @ you in chat): #{d.at_me_consent ? "Yay" : "Nay"}
    peas: #{d.points} Waaat"
  else
    next "we couldn't find you; have you already !start_record ?"
  end
end
