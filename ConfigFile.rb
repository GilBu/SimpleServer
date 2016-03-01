#!/usr/bin/ruby

class ConfigFile

    def initialize(new_config)
        # Do something
        @lines = new_config
    end

   # Split array of line into array of tokens.
    def load
        # Strip out blank and comment lines.
        # Returns array.  0 element is the key
        # 0 < elements are the values.  
        # Modify in place using !. 
        @lines.select! do |line|
            line.strip.length != 0
        end.select! do |line|
            line[0] != '#'
        end.map! do |line|
            line.split(" ")
        end

        self
    end

end
