#!/usr/bin/ruby

class Request
    def initialize(stream)
        @stream = stream
    end

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

        # Print the request to the console.
        puts "\n#{@verb} #{@uri} #{@version}"
        @headers.each do |key, value|
            puts "#{key}: #{value}"
        end
    end

    # Returns false if the next line returned by a socket is nil.
    def next_line_readable?(socket)
        readfds, writefds, exceptfds = select([socket], nil, nil, 0.1)
        readfds # Will be nil if next line cannot be read
    end

end
