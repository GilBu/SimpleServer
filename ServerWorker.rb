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
       request = Request.new(@client).parse
       resource = Resource.new(request.uri, @config, @mimes)
       response =  ResponseFactory.create(request ,resource, @config)
       @client.puts(response)
       @logger.write(request, response)
       @client.close
    end
end
