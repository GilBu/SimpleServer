 #!/usr/bin/ruby

require 'socket'
require 'pathname'
require_relative 'ServerWorker.rb'
require_relative 'Logger.rb'
require_relative 'http/Request.rb'
require_relative 'http/Response.rb'
require_relative 'http/config/HttpConfig.rb'
require_relative 'http/config/MimeTypes.rb'

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
        # Load configs.
        @httpd_config = HttpConfig.new(read_config_file("httpd.conf")).load.process_lines
        @mime_types = MimeTypes.new(read_config_file("mime.types")).load.process_lines

        # Create logger object.  Arg is log file path from httpd object.
        logger = Logger.new(@httpd_config.log_file)

        # Open a socket on the specified port.
        server = TCPServer.open @port 

        # Acknowledge the server is running.
        puts "Server started.  Listening on port #{@port}.\n"

        # Event loop.
        loop do
            # Wait for a connection.
            socket = server.accept
            # Create a new thread to handle request
            Thread.new do
                ServerWorker.new(socket, @httpd_config, @mime_types, logger).process_request
            end
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
