require "http/server"
require "openssl/hmac"
require "json"

class Bobbie
  def initialize
    @http_server = HTTP::Server.new do |context|
      # routes
      case context.request.path
      when "/"
        context.response.print "landing zone"
      when "/webhooks/callback"
        handle_webhook_callback(context)
      else
        puts "💁 THIS IS YOUR SERVER SPEAKING: they tried to go #{context.request.path}"
        context.response.print "ay, you thar! where do you think you're going?!"
      end
      context.response.content_type = "text/plain"
    end
  end

  def listen(server_port = 8080)
    # place all this in a config file! (yaml??)
    # what happens if the port is occupied??
    # - TBM feature: prompt user for another port
    spawn do
      address = @http_server.bind_tcp(server_port)
      puts "Listening on http://#{address}"
      @http_server.listen
    end
    spawn do
      `pagekite.py #{server_port} whereisxbotakacharlie.pagekite.me`
    end
  end

  def goodbye
    @http_server.close
    # temporary solution:
    # pray to the gc / threading gods that pagekite closes
  end

  def handle_webhook_callback(context)
    if body = context.request.body
      raw_body = body.gets_to_end
      if actually_twitch?(context.request.headers, raw_body)
        reply_to_twitch(context, raw_body)
      else
        puts "💁 THIS IS YOUR SERVER SPEAKING: they not actually twitch >:("
        context.response.status = HTTP::Status::FORBIDDEN
      end
    end
  end

  def reply_to_twitch(context, raw_body)
    puts "💁 THIS IS YOUR SERVER SPEAKING: twitch hit us"
    jaybay = JSON.parse(raw_body)
    puts "\n#{jaybay}\n\n"
    if jaybay["challenge"]?
      context.response.print jaybay["challenge"]
    elsif jaybay["event"]?
      user = jaybay["event"]["user_name"]?
      broadcaster = jaybay["event"]["broadcaster_user_name"]?
      puts "💁 THIS IS YOUR SERVER SPEAKING: #{user} followed #{broadcaster}"
    end
  end

  # verify that the request is valid (actually from twitch)
  # derived from twitch api: https://dev.twitch.tv/docs/eventsub#pseudocode
  def actually_twitch?(headers, raw_body)
    hmac_message = headers["Twitch-Eventsub-Message-Id"] +
                   headers["Twitch-Eventsub-Message-Timestamp"] +
                   raw_body
    signature = OpenSSL::HMAC.hexdigest(
      algorithm: OpenSSL::Algorithm::SHA256,
      key: ENV["TWITCH_HMAC_KEY"],
      # key: "ducks are getting hungry",
      data: hmac_message,
    )
    expected_signature_header = "sha256=" + signature
    result = headers["Twitch-Eventsub-Message-Signature"] == expected_signature_header
    p! result
    return result
  end

  def extract(body)
    # body.to_json(JSON::Any)
  end
end
