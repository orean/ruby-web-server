require 'socket'
require 'securerandom'
require 'cgi'
require 'json'

server = TCPServer.new 1985

def client_req(session)
    method, full_path, proto = session.gets.split
    path, query = full_path.split('?')
    query.nil? ? query_params = "" : query_params = CGI::parse(query)
    headers = {}
    while line = session.gets.split(' ', 2)
        break if line[0] == ""
        headers[line[0].chop] = line[1].strip
    end
    data = session.read(headers["Content-Length"].to_i)

    request = {
        "REQUEST_METHOD" => method, 
        "PATH_INFO" => path,
        "QUERY_STRING" => query_params,
        "HEADERS" => headers,
        "BODY" => data
    }
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

def server_resp(x_req_id, req)
    "#{server_resp_200OK}\r\nX-Request-ID: #{x_req_id}\r\nContent-Type: application/json\r\n\r\n#{req.to_json}"
end

while session = server.accept
    request = client_req(session)
    log_uid = SecureRandom.hex(10)
    log_client_req(request, log_uid)
    session.print server_resp(log_uid, request)
    log_server_resp(server_resp_200OK, log_uid)
    session.close
end