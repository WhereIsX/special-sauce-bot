require "./command.cr"
require "../../models/leak.cr"

Command.new(
  name: "!leaked",
  description: "show help on specified command, or list commands if none specified; !help <command>"
) do |ircm|
  leak_record = Model::Leak.order(created_at: :desc).limit(1).select.first

  next "there were no leaks 🙃" if leak_record.nil?
  span = Time.utc - leak_record.created_at
  if span > 1.days
    next "#{span.days} days since we last ducked up"
  elsif span > 1.hours
    next "#{span.hours} hours since we last ducked up"
  else
    next "#{span.minutes} minutes since we last ducked up"
  end
  next "heyyo"
end
