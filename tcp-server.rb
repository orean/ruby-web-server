require 'socket'
require 'securerandom'

server = TCPServer.new 1985

def client_req(session)
    method, path, proto = session.gets.split
    headers = {}
    while line = session.gets.split(' ', 2)
        break if line[0] == ""
        headers[line[0].chop] = line[1].strip
    end
    data = session.read(headers["Content-Length"].to_i)

    request = {"method" => method, "headers" => headers, "body" => data}
end

def server_resp_200OK
    response = "HTTP/1.1 200 OK"
end

def log_client_req(request, uid)
    print Time.now
    print " request_id=#{uid} - server accepted client req: "
    puts request
end

def log_server_resp(response, uid)
    print Time.now
    print " request_id=#{uid} - server responsed to client: "
    puts response
end

while session = server.accept
    request = client_req(session)
    log_uid = SecureRandom.hex(10)
    log_client_req(request, log_uid)
    session.puts server_resp_200OK
    session.puts "X-Request-ID: #{log_uid}"
    log_server_resp(server_resp_200OK, log_uid)
    session.close
end

server.close