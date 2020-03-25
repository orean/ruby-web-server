require 'socket'

server = TCPServer.new 1985

while session = server.accept
    
    method, path, proto = session.gets.split
    headers = {}
    while line = session.gets.split(' ', 2)
        break if line[0] == ""
        headers[line[0].chop] = line[1].strip
    end
    data = session.read(headers["Content-Length"].to_i)

    puts "#{method} #{path} #{proto}"
    puts headers
    puts "\r\n"
    puts data

    session.puts "HTTP/1.1 200 OK\r\n"
    session.puts "Content-Type: text/html\r\n"
    session.puts "\r\n"
    session.puts "Hello world!"
    session.close
end

server.close