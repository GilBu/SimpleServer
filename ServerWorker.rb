 #!/usr/bin/ruby

require_relative "Resource.rb"

class ServerWorker
    # Public:  Operates on an independant thread made in SimpleServer

    def initialize(socket, config, logger)
        @client = socket
        @config = config
        @logger = logger
    end

    def process_request
        # Parse the http request.
        http_request = Request.new(@client) 
        # Get resource.
        # NOT CERTAIN HOW WE GET A mime_type OBJECT HERE.      
#       resource = Resource.new(http_request.uri, @config, mime_types)
        # Send the http response.
       http_response = Response.new(http_request.parse)
       # CANT USE THE FACTORY WITHOUT THE RESOURCE.
  #     response =  ResponseFactory.create(http_request,resource) 
        @client.puts(http_response.to_s)
        # Remember to close the connection.
        @client.close
        # Log request.
        @logger.write(http_request, http_response)
    end
end
