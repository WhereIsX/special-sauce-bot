require "./restful_server.cr"
require "http/server"

address = RESTFUL_SERVER.bind_tcp 8081
puts "Listening on http://#{address}"
RESTFUL_SERVER.listen
