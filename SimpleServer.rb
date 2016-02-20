 #!/usr/bin/ruby

require 'socket'
require_relative 'Request.rb'
require_relative 'Response.rb'

class SimpleServer
    def initialize(port)
        @port = port
    end

    def start
        server = TCPServer.open @port 

        # Acknowledge the server is running.
        puts "Server started.  Listening on port #{@port}.\n"

        # Wait for a connection.
        loop do
            # Accept the connection.
            socket = server.accept
            # Parse the http request.
            Request.new(socket).parse 
            # Send the http response.
            socket.puts Response.new.to_s
            # Close the connection.
            socket.close
        end
    end
end
