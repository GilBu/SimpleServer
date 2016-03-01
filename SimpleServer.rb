 #!/usr/bin/ruby

require 'socket'
require 'pathname'
require_relative 'Request.rb'
require_relative 'Response.rb'
require_relative 'ConfigFile.rb'
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
        @httpd_config = HttpConfig.new(read_config_file("httpd.conf")).load.process_lines
        @mime_types = MimeTypes.new(read_config_file("mime.types")).load.process_lines

        # Check the document root for a .htaccess file.
        if htaccess?(@httpd_config.document_root)
            p "FOUND IT!"
        else
            p "NO .htaccess file..."
        end

        # Test calls to config objects.
        #p @httpd_config.listen
        #p @httpd_config.server_root
        #p @httpd_config.document_root
        #p @httpd_config.log_file
        #p @httpd_config.script_alias("/cgi-bin/")
        #p @httpd_config.alias("/ab/")
        #p @httpd_config.alias("/~traciely/")
        #p @mime_types.for("html")

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

    def htaccess?(document_root)
        Pathname.new(document_root.concat(".htaccess")).exist?
    end

end
