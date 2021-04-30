require "./command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!water",
  description: "attempts to water a named duck; !water <ducky_name>"
) do |ircm|
  # TBD: randomly picks a duck and tags them, asking them to drink
  # words: ("!water", "duckyname")
  if ircm.words.size != 2
    next "you wat. it's !water <ducky_name>"
  end
  duckie = Ducky.find_by(username: ircm.words[1].downcase)
  if duckie.nil?
    next "no such duckie, have they `!start_record` yet?"
  elsif duckie.at_me_consent
    next "HYDRATE #{duckie.username}! go get your feathers wet :>"
  else
    next "they didn't give us consent to water them :<"
  end
end
