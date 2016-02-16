#!/usr/bin/ruby

require 'socket'

class SimpleServer
    def initialize(port)
        @port = 8080
    end

    def start
        server = TCPServer.open @port 

        puts "Server started.  Listening on port #{@port}."

        loop do
            client = server.accept
            client.puts "Communication started at #{Time.now}"
            client.puts "I am going to sleep for 5.0s now..."
            sleep 5.0
            client.puts "Communication ended at #{Time.now}"
            client.close
        end
    end
end
