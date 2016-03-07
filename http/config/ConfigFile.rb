#!/usr/bin/ruby

class ConfigFile

    def initialize(config_lines)
        # Do something
        @lines = config_lines
    end

    def load()

    	@config_hash = {}

    	@lines.each do |key_value_pair|
    		key , value = key_value_pair.split(" ")
    		@config_hash[key.to_sym] = value
    	end

    	@config_hash
    end

end
