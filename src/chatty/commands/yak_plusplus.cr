require "./command.cr"
require "../../models/yak.cr"
require "../../data/constants_collection.cr"

Command.new(
  name: "!yak++",
  description: "increment our yak counter and optionally specify the topic we shaved; \
  !yak++ <optional: topic>",
  species: "dynamic"
) do |ircm|
  yak = Model::Yak.new(created_at: Time.utc)
  if ircm.words[1..].join(' ')
    yak.topic = ircm.words[1..].join(' ')
  else
    yak.topic = ""
  end

  if yak.save
    yaks_shaved = Model::Yak.where(:created_at, :gt, 12.hours.ago).select.size
    case yaks_shaved
    when 0
      next "yaks are wooly! here're some Shears :>"
    else
      next "that's #{yaks_shaved} now! " + YAK_INC_RESP.sample
    end
  else
    next "couldn't shave. Waaat"
  end
end
