 #!/usr/bin/ruby

require 'socket'
require_relative 'Request.rb'
require_relative 'Response.rb'
require_relative 'HttpConfig.rb'
require_relative 'MimeTypes.rb'

class ServerWorker
    # Public:  Operates on an independant thread made in SimpleServer

    def initialize(socket)
        @socket = socket
        @socket.puts("connected to worker")
    end

    def processRequest
        # Parse the http request.
        http_request = Request.new(@socket).parse 
        # Send the http response.
        @socket.puts Response.new(http_request).to_s
    end
end
