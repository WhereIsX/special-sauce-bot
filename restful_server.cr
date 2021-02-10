require "http/server"
require "openssl/hmac"
require "json"

RESTFUL_SERVER = HTTP::Server.new do |context|
  # routes
  case context.request.path
  when "/"
    context.response.print "landing zone"
  when "/webhooks/callback"
    if actually_twitch?(context.request.headers, context.request.body)
      webhook_callback(context)
    else
      puts "💁 THIS IS YOUR SERVER SPEAKING: they not actually twitch >:("
      context.response.status = HTTP::Status::FORBIDDEN
    end
  else
    puts "💁 THIS IS YOUR SERVER SPEAKING: they tried to go #{context.request.path}"
    context.response.print "ay, you thar! where do you think you're going?!"
  end
  context.response.content_type = "text/plain"
end

def webhook_callback(context)
  puts "💁 THIS IS YOUR SERVER SPEAKING: twitch hit us"
  if body = context.request.body
    jaybay = JSON.parse(body)
    puts "\n#{jaybay}\n\n"
    if jaybay["challenge"]?
      context.response.print jaybay["challenge"]
    elsif jaybay["event"]?
      user = jaybay["event"]["user_name"]?
      broadcaster = jaybay["event"]["broadcaster_user_name"]?
      puts "💁 THIS IS YOUR SERVER SPEAKING: #{user} followed #{broadcaster}"
    end
  end
end

# verify that the request is valid (actually from twitch)
# derived from twitch api: https://dev.twitch.tv/docs/eventsub#pseudocode
def actually_twitch?(headers, body)
  hmac_message = headers["Twitch-Eventsub-Message-Id"] +
                 headers["Twitch-Eventsub-Message-Timestamp"] +
                 body.to_s
  signature = OpenSSL::HMAC.hexdigest(
    algorithm: OpenSSL::Algorithm::SHA256,
    key: ENV["TWITCH_HMAC_KEY"],
    # key: "ducks are getting hungry",
    data: hmac_message,
  )
  expected_signature_header = "sha256=" + signature

  return headers["Twitch-Eventsub-Message-Signature"] == expected_signature_header
end

def extract(body)
  # body.to_json(JSON::Any)
end
