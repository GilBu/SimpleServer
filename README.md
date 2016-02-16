# SimpleServer
CSc667 HTTP Server Project

How to run:
    1) Clone the repository.
    2) Run irb from the root directory of SimpleServer.
        $ cd SimpleServer && irb
    3) From irb, load SimpleServer.rb and create a new instance of it
       on port 8080.
        > require_relative 'SimpleServer.rb'
        > SimpleServer.new(8080).start
    4) Open another terminal and run the client.
        $ ./SimpleClient.rb

