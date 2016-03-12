#!/usr/bin/ruby

class Logger 
    def initialize(filepath)
        @filepath = filepath
    end

    def write(request, response)
        # Open log file for writting.
        @file = File.open(@filepath, "a")
        
        # Log entry
        request.headers.each do |key, value|
            # PROPER HEADERS NEED TO BE SELECTED.
            @file.write("#{key}: #{value}\n")
        end
        
        # Close log fil.
        @file.close
    end

end
