 #!/usr/bin/ruby

require 'socket'

class SimpleServer
    def initialize(port)
        @port = port
    end

    def start
        server = TCPServer.open @port 

        # The message that will be dispayed in the browser.
        message_body = "<html><body><h3>Hello, World!</h3></body></html>"

        # The response message.
        http_response = "HTTP/1.1 200 OK
        Date: #{Time.new.to_s}
        Server: OUR HTTP SERVER
        Last-Modified: Wed, 22 Jul 2009 19:15:56 GMT
        Content-Length: #{message_body.length}
        Content-Type: text/html
        Connection: Closed\n\n"

        # Acknowledge the server is running.
        puts "Server started.  Listening on port #{@port}."

        # Wait for requests.
        loop do
            client = server.accept
            client.puts http_response
            client.puts message_body 
            client.close
        end
    end
end
