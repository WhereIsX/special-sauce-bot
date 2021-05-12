require "./command.cr"
require "../../models/yak.cr"

Command.new(
  name: "!yak_count",
  description: "nexts how many yaks we shaved today",
  species: "dynamic"
) do |ircm|
  yaks = Model::Yak.where(:created_at, :gt, 12.hours.ago).select.size

  if yaks.zero?
    next "the yaks are woolly; here're some Shears have a nice day!"
  else
    next yaks.to_s
  end
end
