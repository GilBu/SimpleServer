 #!/usr/bin/ruby

require 'socket'
require_relative 'Request.rb'

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

        # Wait for a connection.
        loop do
            # Accept the connection.
            socket = server.accept

            # Print the http request sent from the browser.
            # Ensure that the next line returned by the socket
            # does is not nil, or the while loop will hang.
            # Note: Some browser will send multiple http_requests
            #       e.g. chrome, opera
            puts "*** CONNECTION INITIATED  ***\n\n"
            #while next_line_readable?(socket) 
                #puts socket.gets.chomp
            #end
            Request.new(socket).parse 

            puts "\n*** CONNECTION TERMINATED ***\n\n"
            # Send http response to the browser.
            socket.puts http_response
            socket.puts message_body 

            # Close the connection.
            socket.close
        end
    end

    # Returns false if the next line returned by a socket is nil.
    def next_line_readable?(socket)
        readfds, writefds, exceptfds = select([socket], nil, nil, 0.1)
        readfds # Will be nil if next line cannot be read
    end

end
