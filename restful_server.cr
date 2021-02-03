RESTFUL_SERVER = HTTP::Server.new do |context|
  # routes
  case context.request.path
  when "/"
    context.response.print "landing zone"
  when "/webhooks/callback"
    # if actually_twitch?(header)
    #   extract important info
    # else
    #   buzz off! (send a 418 teapot, 420 enhance calm, 425 too early)
    # end
  else
    context.response.print "ay, you thar! where do you think you're going?!"
  end
  context.response.content_type = "text/plain"
end

# verify that the request is valid (actually from twitch)
def actually_twitch?(header)
end

def extract(body)
  # body.to_json(JSON::Any)
end
