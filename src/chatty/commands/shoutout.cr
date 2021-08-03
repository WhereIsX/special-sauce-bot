require "http"
require "./command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!so",
  description: "shoutouts another streamer; !so <username>"
) do |ircm|
  _, arg = Command.parse_ircm(ircm)
  if arg.empty?
    next "you wat. who're you trying to shout at?"
  end
  channel_name = arg.first
  next "nice try, 👅" if !Model::Ducky.valid_username?(channel_name)
  # search_result = `twitch api get search/channels?query=#{duckie_args}`
  # data = JSON.parse(search_result).dig("data") # => JSON::Any
  # user = data.as_a.find { |user| user["display_name"].to_s.downcase == duckie_args.downcase }

  query_string = URI::Params.encode({"query" => channel_name})
  headers = HTTP::Headers{
    "Client-ID"     => ENV["TWITCH_APP_ID"],
    "Authorization" => "Bearer #{ENV["TWITCH_APP_ACCESS_TOKEN"]}",
  }

  result = HTTP::Client.get(
    url: URI.new(
      scheme: "https",
      host: "api.twitch.tv",
      path: "/helix/search/channels",
      query: query_string,
    ),
    headers: headers,
  )

  if !result.success?
    p! ":( we failed"
    next "go check out twitch.tv/#{channel_name} right meow! they're kinda magical"
  end
  data = JSON.parse(result.body).dig("data") # => JSON::Any
  user = data.as_a.find { |user| user["display_name"].to_s.downcase == channel_name.downcase }

  if user
    next "go check out twitch.tv/#{user["display_name"]}, they were last working on '#{user["title"]}'"
  else
    next "you can't spell mate"
  end
  # end
end
