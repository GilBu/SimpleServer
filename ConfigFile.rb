#!/usr/bin/ruby

class ConfigFile

    def initialize(new_config)
        # Do something
        @config_array = new_config
    end

    # Implement me.

    def process_line()

    	@config_hash = {}

    	@config_array.each do |key_value_pair|
    		key , value = key_value_pair.split(" ")
    		@config_hash[key.to_sym] = value
    	end

    	@config_hash
    end

end
