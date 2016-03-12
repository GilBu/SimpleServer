 #!/usr/bin/ruby

require_relative "Resource.rb"
require_relative "http/Request.rb"
require_relative "ResponseFactory.rb"

class ServerWorker
    def initialize(socket, config, mimes, logger)
        @client = socket
        @config = config
        @mimes = mimes
        @logger = logger
    end

    def process_request
        # Parse the http request.
       request = Request.new(@client).parse
       resource = Resource.new(request.uri, @config, @mimes)
       # Factory needed a resource so I had to add a mimes object as a memeber. 
       # Create the response.
       response =  ResponseFactory.create(request ,resource) 
       @client.puts(response)
       @client.close
       # Log request.
       @logger.write(request, response)
    end
end
