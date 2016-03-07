#!/usr/bin/ruby

class Logger 
    def initialize(filepath)
        @filepath = filepath
    end

    def write(request, response)
        # Open log file for writting.
        log = File.open(@filepath, "a")
        
        # Form log entry - PROPER HEADERS NEED TO BE SELECTED.
        request.headers.each do |key, value|
            log.write("#{key}: #{value}\n")
        end
        
        # Close log fil.
        log.close
    end

end
