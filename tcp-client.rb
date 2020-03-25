require 'socket'

socket = TCPSocket.new 'localhost', 1985

puts "Starting the Client..................."

while response = socket.gets.chomp
    puts response
    message = STDIN.gets.chomp 
    socket.puts message
    puts "message successfully send to server!"
    break if message == 'CLOSE'
end


puts "Closing the Client..................."
socket.close