require "./command.cr"
require "../../models/ducky.cr"

earnings = 10
cd = 1

Command.new(
  name: "!water",
  description: "attempts to water a named duck (earns #{earnings} peas, cooldown #{cd} min); !water <ducky_name>"
) do |ircm|
  # TBD: randomly picks a duck and tags them, asking them to drink
  # words: ("!water", "duckyname")

  # gardener - ducky doing the watering
  # plant - ducky being watered
  gardener, args = Command.parse_ircm(ircm)

  if gardener.nil?
    next "you must have a record with us to water others, try !start_record"
  end

  # not yet passed cooldown
  now = Time.utc
  if gardener.next_water && gardener.next_water > now
    next "you still have #{(gardener.next_water - now).seconds}s left before you can use this command again"
  end

  if args.size != 1
    next "you wat. it's !water <ducky_name>"
  end

  plant = Model::Ducky.find_by(username: ircm.words[1].downcase)
  if plant.nil?
    next "no such duckie, have they `!start_record` yet?"
  end

  if plant.at_me_consent
    gardener.next_water = Time.utc + cd.minutes
    gardener.points += earnings
    gardener.save
    next "HYDRATE #{plant.username}! go get your feathers wet :>"
  else
    next "they didn't give us consent to water them :<"
  end
end
