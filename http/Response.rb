#!/usr/bin/ruby

class Response
    attr_accessor :headers, :response_code, :response_phrase

    # Add params lists.
    # Add response code hash.
    # Add inner class for headers - with to_s method.

    def initialize(response_code,body, mime_type="text/html")
        @version = 1.1
        @response_code = response_code
        @response_phrase = get_phrase(response_code)
        @mime_type = mime_type
        @headers = Hash.new 
        @body = "#{body}"
    end

    # Public : Builds the http response string.
    #
    # Returns The http response string.
    def to_s
        headers = ''
        @headers.each do | key, value |
            headers = "#{key}: #{value}\n"
        end
        "HTTP/#{@version} #{@response_code} #{@response_phrase}\n"\
        "Date: #{Time.now}\n"\
        "Connection: close\n"\
        "Server: csc667 Server Project\n"\
        "Content-Type: #{@mime_type}\n"\
        "Content-Length: #{@body.length+1}\n"\
        "Last-Modified: #{Time.now}\n"\
        "#{headers}\n\n"\
        "#{@body}"
    end

    private def get_phrase(response_code)
        case response_code
            when 200
                "OK"
            when 201 
                "Created"
            when 304
                "Not Modified"
            when 400
                "Bad Request"
            when 401
                "Unauthorized"
            when 403
                "Forbidden"
            when 404
                "Not Found"
            when 500
                "Internal Server Error"
            end
    end
end
