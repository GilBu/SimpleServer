#!/usr/bin/ruby

class Logger 
    def initialize(filepath)
        @filepath = filepath
    end

    def write(request, response)
        # Open log file for writting.
        @file = File.open(@filepath, "a")
        
        # Build the log string.
        log_entry = IPSocket.getaddress("localhost")
#        log_entry << "\t#{request.headers['identd']}" # Ask for clarification.
#        log_entry << "\t#{request.headers['auth']}"   # This one too.
        log_entry << "\t#{Time.now}"
        log_entry << "\t#{request.verb} #{request.uri} #{request.version}"
        log_entry << "\t#{response.response_code}/#{response.response_phrase}"
        log_entry << "\t#{response.to_s.bytesize}\n"
        # Log entry
        @file.write(log_entry)
        # Close log fil.
        @file.close
    end

end
