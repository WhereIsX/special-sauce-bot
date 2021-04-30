require "./command.cr"
require "../../models/yak.cr"

Command.new(
  name: "!todayishaved",
  description: "lists all the tangents we've gone on"
) do |ircm|
  yaks = Yak.where(:created_at, :gt, 12.hours.ago)
    .where(:topic, :neq, "")
    .select

  topics = yaks.map { |yak| yak.topic }.join(", ")
  next "today we shaved: #{topics}"
end
