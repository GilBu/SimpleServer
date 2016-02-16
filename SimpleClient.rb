#!/usr/bin/ruby

require 'socket'

PORT = 8080

s = TCPSocket.open 'localhost', PORT

while line = s.gets
    puts line
end

s.close
