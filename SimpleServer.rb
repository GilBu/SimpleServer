 #!/usr/bin/ruby

require 'socket'
require_relative 'Request.rb'
require_relative 'Response.rb'
require_relative 'HttpConfig.rb'
require_relative 'MimeTypes.rb'

class SimpleServer
    def initialize(port)
        @port = port
    end

    # Public:  Starts the server.
    #
    # Examples
    #
    #   SimpleServer.new(8080).start
    def start
        @httpd_config = HttpConfig.new(read_config_file("httpd.conf"))
        @mime_types = MimeTypes.new(read_config_file("mime_types.conf"))

        # Open a socket on the specified port.
        server = TCPServer.open @port 

        # Acknowledge the server is running.
        puts "Server started.  Listening on port #{@port}.\n"

        # Wait for a connection.
        loop do
            # Accept the connection.
            socket = server.accept
            # Parse the http request.
            http_request = Request.new(socket).parse 
            # Send the http response.
            socket.puts Response.new(http_request).to_s
            # Close the connection.
            socket.close
        end
    end

    # Private:  Splits a config file's lines into an array.
    #
    # config_file - The name of the config file.
    #
    # Examples
    #
    #   read_config_file("httpd.conf")
    #   # => ["Line One", "Line Two", "Line Three"]
    #
    # Returns an array containing the file's line.
    private def read_config_file(config_file)
        # Build the path to the config.
        config_path = "config/" << config_file

        # Open file and split into an array.
        config_array = Array.new
        File::open(config_path, "r") do |file|
            file.each do |line|
                config_array.push line
            end
            # File is automatically closes
            # upon end of code block.
        end
            
        # Return the array.
        config_array 
    end

end
