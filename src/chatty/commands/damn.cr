require "./command.cr"
require "../../models/leak.cr"

Command.new(
  name: "!damn",
  description: "auduckrized use only: we lost some keys to the public"
) do |ircm|
  ducky, args = Command.parse_ircm(ircm)
  # we dont want just any regular user calling this method (prevent abuse!)
  if ducky.nil? || ducky.username != ENV["CHANNEL_NAME"] # is env var a good idea???
    next "not authorized to record a new !leaked keys time"
  end

  leak = Model::Leak.new(created_at: Time.utc)
  if leak.save
    next "you get a new key! you get a new key! EVERYBODY GETS A NEW KEY!!"
  else
    next "create_new_leak is busted :("
  end
end
