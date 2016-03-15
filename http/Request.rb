#!/usr/bin/ruby

class Request
    attr_reader :stream, :verb, :uri, :version, :headers, :body

    def initialize(stream)
        @stream = stream
    end

    # Public : Parses a stream for http requests.
    #
    # stream - An accepted socket connection. 
    #
    # Returns The http request string (temp)
    def parse
        @headers = Hash.new
         
        # Parse request stream line by line.
        while next_line_readable?(@stream) 
            # Compare line to reqex and store.
            case line = @stream.gets.chomp
            when /^[A-Z]* \/.* HTTP\/[0-9].[0-9]$/
                @verb, @uri, @version = line.split
            when /^[A-Z].*: .*$/
                key, value = line.split(": ")
                @headers[key] = value
            when /^<[a-z]*>.*<\/[a-z]*>$/
                @body = line
            end
        end

        ### REMOVE LATER ###
        # Build and return the request string so the 
        # server can send it to the client for testing.
        str_builder =  "#{@verb} #{@uri} #{@version}<br>\n"
        @headers.each do |key, value|
            str_builder << "#{key}: #{value}<br>\n"
        end

        # Print the request string to the console running the server.
        puts "\n#{str_builder}\n"

        # Return the request string so the server can send it in the
        # body of the response to the client. 
        ### END REMOVE LATER ###
        self
    end

     # Private: Checks if the socket is going to return another line. 
     #          Times out after 0.1 secs.
     #
     # socket - A socket connection waiting to be read.
     #
     # Returns NIL if the next line cannot be read.
    private def next_line_readable?(socket)
        readfds, writefds, exceptfds = select([socket], nil, nil, 0.1)
        readfds
    end

end
