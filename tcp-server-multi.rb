require 'socket'

server = TCPServer.new 1985
loop do
  Thread.start(server.accept) do |client|
    client.puts "Hello! This is Multi-threaded server."
    client.puts "Time is #{Time.now}"
    client.close
  end
end