require "./secrets.cr"
require "socket"
require "openssl" # <<??? how was anyone supposed to know to import this??
# questions for sock day
# how can I make sure these socks are encrypted with ssl?
# why do they still call this ssl when its clearly *deprecated*
# wtf is client.puts really doing?
# read through original IRC RFC doc: https://tools.ietf.org/html/rfc1459

TWITCH_TOKEN

tcp_sock = TCPSocket.new("irc.chat.twitch.tv", 6697)
client = OpenSSL::SSL::Socket::Client.new(tcp_sock)

client.puts("PASS #{TWITCH_TOKEN}") #
client.puts("NICK #{BOT_NAME}")
client.puts("JOIN ##{CHANNEL_NAME}")
puts "Connecting... "

client.puts("PRIVMSG ##{CHANNEL_NAME} :testing")
client.close
6
