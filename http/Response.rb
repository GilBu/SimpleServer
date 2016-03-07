#!/usr/bin/ruby

class Response
    def initialize(body)
        @version = 1.1
        @response_code = 200
        @response_phrase = 'OK'
        @headers = Hash.new 
        #@body = '<!DOCTYPE html><html><head></head><body>Hello, CSc667!</body></html>'
        @body = "<!DOCTYPE html><html><head></head><body><h3>Request string sent from the client (this browser):</h3><p>#{body}</p></body></html>"
    end

    # Public : Builds the http response string.
    #
    # Returns The http response string.
    def to_s
        "HTTP/#{@version} #{@response_code} #{@response_phrase}\n"\
        "Date: #{Time.now}\n"\
        "Connection: close\n"\
        "Server: csc667 Server Project\n"\
        "Content-Type: text/html\n"\
        "Content-Length: #{@body}.length\n"\
        "Last-Modified: #{Time.now}\n\n"\
        "#{@body}"
    end
end
